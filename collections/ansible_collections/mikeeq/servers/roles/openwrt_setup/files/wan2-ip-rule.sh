#!/bin/sh
# Route packets marked 0xc8 (from wan2 inbound connections) via table 200
ip rule del fwmark 0xc8 table 200 2>/dev/null
ip rule add fwmark 0xc8 table 200
