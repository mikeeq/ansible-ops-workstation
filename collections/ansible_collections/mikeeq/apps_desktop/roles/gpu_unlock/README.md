# gpu_unlock

Installs [gpu-unlock](https://github.com/Zagitta/gpu-unlock): a kernel module that, at boot and before the
`nvidia` driver binds the card, lifts the GeForce half-rate cap on FP16/BF16/TF32 tensor math with FP32
accumulation (RTX 20/30/40). No VBIOS flash and no patched driver; the change is volatile and is redone on
every boot.

## What it does

1. Asserts that every `gpu_unlock_targets` address is an NVIDIA VGA device.
2. Clones the project at a pinned commit and builds the upstream RPMs (`make rpm`). The build downloads the
   pinned NVIDIA 610.43.03 driver from `download.nvidia.com` only to extract firmware; the spec checks both
   files against sha256 sums.
3. Installs `gpu-unlock-dkms` and `gpu-unlock-firmware`: DKMS builds the module for every kernel with
   headers and dracut puts it in the initramfs. Without the kernel argument the module does nothing.
4. Adds `gpu_unlock.targets=<pci addresses>` to every boot entry (`grubby`).

The role never reboots. Reboot manually, then check:

```sh
journalctl -k -b | grep gpu_unlock    # "gpu_unlock: unlocked"
nvidia-smi
```

## Variables

| Variable | Default | Description |
| --- | --- | --- |
| `gpu_unlock_version` | `7eb51bcc…` (v2.0.0) | Pinned commit; review the diff before bumping |
| `gpu_unlock_targets` | `["0000:06:00.0"]` | PCI addresses (`lspci -D`). mikeeClevo also has an unsupported GTX 880M at `01:00.0`, so no `all` |
| `gpu_unlock_state` | `present` | `absent` removes the kernel argument and the packages |

## Risks and rollback

- The unlock runs NVIDIA's signed Booter firmware with a crafted call frame (see the upstream
  `docs/How Ampere was unlocked.md`). If the GPU firmware hangs, the card stays unusable until a full power
  off; a warm reboot is not enough.
- One-off boot without it: remove `gpu_unlock.targets=` in the GRUB edit screen.
- Permanent: `-e gpu_unlock_state=absent`, reboot, and power-cycle if the card is still unlocked.
- The kernel is versionlocked on mikeeClevo; after a kernel update check `dkms status` before rebooting.

## Expected gain on mikeeClevo

Only FP16/BF16/TF32 tensor work speeds up. FP32 without TF32, INT8, NVENC/NVDEC (Frigate ffmpeg) and
memory-bound LLM decoding do not change. Frigate (YOLO-NAS ONNX, embeddings) and Immich ML run FP32 ONNX
models, so measure before/after instead of expecting the advertised +80 % BF16.
