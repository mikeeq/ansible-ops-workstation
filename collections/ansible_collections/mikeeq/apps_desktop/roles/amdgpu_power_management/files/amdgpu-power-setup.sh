#!/bin/bash

# AMD GPU Power Management Script
# This script sets up power and clock constraints for AMD GPU

# Target PCI address - adjust if your GPU is on a different bus
GPU_PCI_ADDR="0000:03:00.0"

# Power cap in nanowatts (294000000 = 294W)
POWER_CAP=294000000

# OD Profile Command file
OD_CMD_FILE="/sys/module/amdgpu/drivers/pci:amdgpu/${GPU_PCI_ADDR}/pp_od_clk_voltage"

# Power cap file
POWER_CAP_FILE="/sys/module/amdgpu/drivers/pci:amdgpu/${GPU_PCI_ADDR}/hwmon/hwmon2/power1_cap"

# Verify required files exist
if [[ ! -f "${OD_CMD_FILE}" ]]; then
    echo "Warning: OD command file not found at ${OD_CMD_FILE}"
    echo "Make sure amdgpu driver is loaded and device is accessible"
    exit 1
fi

if [[ ! -f "${POWER_CAP_FILE}" ]]; then
    echo "Warning: Power cap file not found at ${POWER_CAP_FILE}"
    echo "Make sure amdgpu driver is loaded and device is accessible"
    exit 1
fi

# 2945Mhz default
# 2550Mhz - ~250W hotspot 88C
# 2450Mhz - ~220W hotspot 75C (a lot quieter than 2550Mhz)
# 2350Mhz - ~205W hotspot 75C (small noise)
# 2250Mhz - ~190W hotspot 75C (quiet)
# Set OD profile limits: s 1 2050 (Set performance profile to 1, max clock 2050 MHz)
echo "s 1 2350" > "${OD_CMD_FILE}"
# Commit OD profile settings
echo "c" > "${OD_CMD_FILE}"

# Set power cap to 294W
echo "${POWER_CAP}" > "${POWER_CAP_FILE}"

# Verify settings
echo "AMD GPU Power Settings:"
echo "OD Profile:"
cat "${OD_CMD_FILE}"

echo ""
echo "Power Cap:"
cat "${POWER_CAP_FILE}"

# Reset OD profile
# echo "r" > "${OD_CMD_FILE}"

exit 0
