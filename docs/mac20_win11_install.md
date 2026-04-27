# Installing Windows 11 25H2 on MacBook Pro 13" 2020 (Intel i5, T2 chip)

> Tested on MacBook Pro 13" 2020 with Intel i5 and T2 security chip, running macOS Tahoe 26.4.1.

## Overview

Boot Camp does not officially support Windows 11, and the Win11 25H2 ISO is too large for Boot Camp to handle. The workaround is to install Windows 10 first via Boot Camp, then upgrade in-place to Windows 11 25H2 using a forked MediaCreationTool. Secure Boot stays enabled throughout.

## Prerequisites

- MacBook Pro 13" 2020 (Intel, T2 chip)
- macOS Tahoe (latest)
- Internet connection
- Windows 10 22H2 ISO — [download from Microsoft](https://www.microsoft.com/en-gb/software-download/windows10iso)

## Step 1 — Clean macOS install (optional but recommended)

If you have additional partitions (Linux, Windows, etc.), remove them and merge everything back into a single APFS volume, then update macOS to the latest version.

1. Boot into **macOS Recovery** (`Cmd + R` at startup)
2. Open **Disk Utility**, erase the disk as APFS, and reinstall macOS
   - [Apple — Reinstall macOS](https://support.apple.com/en-us/102639)
3. After first boot into the fresh macOS, reboot into Recovery again
4. Re-enable **Secure Boot** (Full Security) — required for T2 factory reset
   - [Apple — T2 chip security](https://support.apple.com/en-us/102664)

## Step 2 — Install Windows 10 via Boot Camp

> **Why not install Windows 11 directly?** Boot Camp does not support Win11, and the 25H2 ISO exceeds the size Boot Camp can handle.

1. Download the [Windows 10 22H2 ISO](https://www.microsoft.com/en-gb/software-download/windows10iso)
2. Open **Boot Camp Assistant** on macOS and follow the prompts to install Windows 10
3. During Windows 10 setup:
   - **Do not enter a product key** (skip when prompted)
   - Create a **local account only** (skip Microsoft account sign-in)
4. Once installed, run **Windows Update** and install all available updates

Reference: [Reddit — Guide: How to install Windows 11 on your Intel Mac](https://www.reddit.com/r/bootcamp/comments/1n8etns/guide_how_to_install_windows_11_on_your_intel_mac/)

## Step 3 — Upgrade to Windows 11 25H2

The original [AveYo/MediaCreationTool.bat](https://github.com/AveYo/MediaCreationTool.bat) only supports up to Win11 23H2. Use the fork below which supports 25H2:

1. Go to [yingchingl/MediaCreationTool.bat](https://github.com/yingchingl/MediaCreationTool.bat)
2. Download **only** the `MediaCreationTool.bat` file from the `main` branch
3. Right-click the downloaded file and **Run as Administrator**
4. Select **Windows 11 25H2** when prompted and follow the in-place upgrade steps

The upgrade preserves your existing data and drivers. Secure Boot remains enabled.

## Result

Windows 11 25H2 running on MacBook Pro 13" 2020 via Boot Camp with Secure Boot enabled.
