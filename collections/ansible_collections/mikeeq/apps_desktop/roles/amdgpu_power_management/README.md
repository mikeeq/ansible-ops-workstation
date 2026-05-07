# AMD GPU Power Management Role

This Ansible role configures AMD GPU power management settings for Fedora systems by:
- Setting OD profile limits (performance profile and max clock)
- Setting power cap (default: 294W)
- Creating a systemd service that runs these settings on startup

## Requirements

- Fedora 43 or compatible
- AMD GPU with amdgpu driver loaded
- Systemd-based init system

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `amdgpu_pci_addr` | `0000:03:00.0` | PCI address of the AMD GPU device |
| `amdgpu_power_cap` | `294000000` | Power cap in nanowatts (294000000 = 294W) |

## Usage

### Basic Usage

Run the playbook on your target hosts:

```bash
ansible-playbook -i inventory/hosts playbooks/amdgpu-power-management.yaml
```

### Custom PCI Address

If your AMD GPU is on a different PCI address, update the variable:

```yaml
- role: amdgpu-power-management
  vars:
    amdgpu_pci_addr: "0000:04:00.0"
```

### Custom Power Cap

To set a different power cap (e.g., 250W):

```yaml
- role: amdgpu-power-management
  vars:
    amdgpu_power_cap: "250000000"
```

### Target Specific Hosts

Only run on specific workstations:

```yaml
- name: Configure AMD GPU Power Management
  hosts: gpu-workstations
  become: true
  roles:
    - role: amdgpu-power-management
```

## What the Service Does

The systemd service (`amdgpu-power-setup.service`) executes the following on startup:

1. Sets OD profile to performance profile 1 with max clock of 2050 MHz
2. Sets power cap to the configured value (default: 294W)
3. Displays current settings
4. Resets OD profile

## Files Created

- `/etc/systemd/system/amdgpu-power-setup.service` - Systemd service file
- `/usr/local/bin/amdgpu-power-setup.sh` - Setup script

## Verification

Check if the service is running:

```bash
systemctl status amdgpu-power-setup
```

View service logs:

```bash
journalctl -u amdgpu-power-setup -f
```

## Manual Testing

Test the script manually before applying with Ansible:

```bash
# Copy script manually
sudo cp roles/amdgpu-power-management/files/amdgpu-power-setup.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/amdgpu-power-setup.sh

# Run manually
sudo /usr/local/bin/amdgpu-power-setup.sh
```

## Troubleshooting

### Service Fails to Start

Ensure the amdgpu driver is loaded:

```bash
lsmod | grep amdgpu
```

### Wrong PCI Address

Find your GPU PCI address:

```bash
lspci | grep -i vga
ls -la /sys/module/amdgpu/drivers/pci:amdgpu/
```

### Power Cap File Not Found

Verify the hwmon directory exists:

```bash
ls -la /sys/module/amdgpu/drivers/pci:amdgpu/0000:03:00.0/hwmon/
```

## References

- [AMDGPU Driver Documentation](https://docs.kernel.org/gpu/amdgpu.html)
- [pp_od_clk_voltage Interface](https://github.com/TomaszModrow/amdgpu-sysfs)
