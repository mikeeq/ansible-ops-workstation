#!/usr/bin/env python3
"""ISP quality monitor — collects speed, ping, and packet loss metrics."""

import json
import logging
import os
import subprocess
import threading
import time

from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS

INFLUX_URL = os.environ.get("INFLUX_URL", "http://influxdb:8086")
INFLUX_TOKEN = os.environ.get("INFLUX_TOKEN", "isp-monitor-token")
INFLUX_ORG = os.environ.get("INFLUX_ORG", "isp-monitor")
INFLUX_BUCKET = os.environ.get("INFLUX_BUCKET", "isp-monitor")

PING_TARGETS = os.environ.get("PING_TARGETS", "8.8.8.8,1.1.1.1,9.9.9.9").split(",")
PING_COUNT = int(os.environ.get("PING_COUNT", "20"))
PING_INTERVAL = int(os.environ.get("PING_INTERVAL", "60"))
SPEEDTEST_INTERVAL = int(os.environ.get("SPEEDTEST_INTERVAL", "900"))
SPEEDTEST_SERVER_ID = os.environ.get("SPEEDTEST_SERVER_ID", "")

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
log = logging.getLogger("collector")


def wait_for_influxdb(client, retries=30, delay=5):
    for i in range(retries):
        try:
            if client.health().status == "pass":
                log.info("InfluxDB ready")
                return
        except Exception:
            pass
        log.info("Waiting for InfluxDB… (%d/%d)", i + 1, retries)
        time.sleep(delay)
    raise RuntimeError("InfluxDB not available after %d attempts" % retries)


def run_ping(target, count):
    try:
        result = subprocess.run(
            ["ping", "-c", str(count), "-W", "5", "-i", "0.5", target],
            capture_output=True, text=True, timeout=count * 2 + 30,
        )
        output = result.stdout
        loss = 100.0
        rtt_min = rtt_avg = rtt_max = rtt_mdev = 0.0

        for line in output.splitlines():
            if "packet loss" in line:
                loss = float(line.split("%")[0].split()[-1])
            if line.strip().startswith("rtt") or line.strip().startswith("round-trip"):
                parts = line.split("=")[1].strip().split("/")
                rtt_min = float(parts[0])
                rtt_avg = float(parts[1])
                rtt_max = float(parts[2])
                rtt_mdev = float(parts[3].split()[0])

        return {
            "target": target,
            "loss_pct": loss,
            "rtt_min": rtt_min,
            "rtt_avg": rtt_avg,
            "rtt_max": rtt_max,
            "rtt_mdev": rtt_mdev,
        }
    except subprocess.TimeoutExpired:
        log.warning("Ping to %s timed out", target)
    except Exception as e:
        log.error("Ping to %s failed: %s", target, e)
    return {
        "target": target,
        "loss_pct": 100.0,
        "rtt_min": 0, "rtt_avg": 0, "rtt_max": 0, "rtt_mdev": 0,
    }


def run_speedtest():
    try:
        cmd = ["speedtest", "--accept-license", "--accept-gdpr", "--format=json"]
        if SPEEDTEST_SERVER_ID:
            cmd += ["--server-id", SPEEDTEST_SERVER_ID]
        result = subprocess.run(
            cmd,
            capture_output=True, text=True, timeout=120,
        )
        if result.returncode != 0:
            log.error("speedtest exited %d: %s", result.returncode, result.stderr)
            return None
        data = json.loads(result.stdout)
        return {
            "download_mbps": data["download"]["bandwidth"] * 8 / 1_000_000,
            "upload_mbps": data["upload"]["bandwidth"] * 8 / 1_000_000,
            "ping_ms": data["ping"]["latency"],
            "jitter_ms": data["ping"].get("jitter", 0),
            "packet_loss": data.get("packetLoss", 0) or 0,
            "server_name": data["server"]["name"],
            "server_id": str(data["server"]["id"]),
            "isp": data.get("isp", "unknown"),
        }
    except Exception as e:
        log.error("Speed test failed: %s", e)
    return None


def write_ping(write_api, ping_result):
    point = (
        Point("ping")
        .tag("target", ping_result["target"])
        .field("loss_pct", ping_result["loss_pct"])
        .field("rtt_min", ping_result["rtt_min"])
        .field("rtt_avg", ping_result["rtt_avg"])
        .field("rtt_max", ping_result["rtt_max"])
        .field("rtt_mdev", ping_result["rtt_mdev"])
    )
    write_api.write(bucket=INFLUX_BUCKET, org=INFLUX_ORG, record=point)


def write_speedtest(write_api, speed_result):
    point = (
        Point("speedtest")
        .tag("server_name", speed_result["server_name"])
        .tag("server_id", speed_result["server_id"])
        .tag("isp", speed_result["isp"])
        .field("download_mbps", speed_result["download_mbps"])
        .field("upload_mbps", speed_result["upload_mbps"])
        .field("ping_ms", speed_result["ping_ms"])
        .field("jitter_ms", speed_result["jitter_ms"])
        .field("packet_loss", speed_result["packet_loss"])
    )
    write_api.write(bucket=INFLUX_BUCKET, org=INFLUX_ORG, record=point)


def ping_loop(write_api):
    while True:
        for target in PING_TARGETS:
            r = run_ping(target, PING_COUNT)
            log.info("Ping %s: loss=%.1f%% avg=%.1fms", target, r["loss_pct"], r["rtt_avg"])
            try:
                write_ping(write_api, r)
            except Exception as e:
                log.error("Write ping data failed: %s", e)
        time.sleep(PING_INTERVAL)


def speedtest_loop(write_api):
    while True:
        log.info("Running speed test…")
        r = run_speedtest()
        if r:
            log.info("Speed: ↓%.1f Mbps ↑%.1f Mbps ping=%.1fms", r["download_mbps"], r["upload_mbps"], r["ping_ms"])
            try:
                write_speedtest(write_api, r)
            except Exception as e:
                log.error("Write speedtest data failed: %s", e)
        else:
            log.error("Speed test returned no results")
        time.sleep(SPEEDTEST_INTERVAL)


def main():
    client = InfluxDBClient(url=INFLUX_URL, token=INFLUX_TOKEN, org=INFLUX_ORG)
    wait_for_influxdb(client)
    write_api = client.write_api(write_options=SYNCHRONOUS)

    log.info("Targets: %s | Ping every %ds | Speedtest every %ds", PING_TARGETS, PING_INTERVAL, SPEEDTEST_INTERVAL)

    threading.Thread(target=ping_loop, args=(write_api,), daemon=True).start()
    speedtest_loop(write_api)


if __name__ == "__main__":
    main()
