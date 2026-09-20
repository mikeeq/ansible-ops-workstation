#!/usr/bin/env bash
#
# fedora-cloud-kernel-boot-fix.sh
#
# Fixes the "kernel upgrades install but VM keeps booting the old kernel"
# problem on stock Fedora Cloud images that use uki-direct + menu-less
# zero-timeout VM firmware.
#
# Default (safe) mode: installs a kernel-install plugin that promotes the
# newest UKI's EFI boot entry to the front of BootOrder on every kernel
# install. No bootloader change, Secure Boot untouched.
#
# Optional mode (USE_SYSTEMD_BOOT=1): installs systemd-boot instead.
# This is riskier under Secure Boot and is guarded accordingly.
#
# Usage:
#   sudo ./fedora-cloud-kernel-boot-fix.sh
#   sudo USE_SYSTEMD_BOOT=1 ./fedora-cloud-kernel-boot-fix.sh   # opt-in
#
set -euo pipefail

log()  { printf '[fix] %s\n' "$*"; }
warn() { printf '[fix][WARN] %s\n' "$*" >&2; }
die()  { printf '[fix][ERROR] %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "Must run as root (use sudo)."

# --- Sanity checks -----------------------------------------------------------
command -v efibootmgr >/dev/null 2>&1 || dnf install -y efibootmgr
[[ -d /sys/firmware/efi ]] || die "Not a UEFI system; this fix does not apply."

USE_SYSTEMD_BOOT="${USE_SYSTEMD_BOOT:-0}"

# --- Detect Secure Boot ------------------------------------------------------
SB_STATE="unknown"
if command -v mokutil >/dev/null 2>&1; then
    SB_STATE="$(mokutil --sb-state 2>/dev/null || true)"
fi
log "Secure Boot state: ${SB_STATE:-unknown}"

# =============================================================================
# MODE 1 (DEFAULT): efibootmgr reorder plugin
# =============================================================================
install_reorder_plugin() {
    local plugin=/etc/kernel/install.d/95-efibootmgr-reorder.install
    log "Installing BootOrder reorder plugin at ${plugin}"

    install -d -m 0755 /etc/kernel/install.d

    cat > "$plugin" <<'PLUGIN'
#!/usr/bin/bash
# Promote the just-installed kernel's EFI boot entry to the front of BootOrder.
# Compensates for uki-direct not reordering BootOrder on menu-less firmware.
COMMAND="$1"
KERNEL_VERSION="$2"

[[ "$COMMAND" == "add" ]] || exit 0
[[ -n "${KERNEL_VERSION:-}" ]] || exit 0
command -v efibootmgr >/dev/null 2>&1 || exit 0

num=$(efibootmgr | grep -F "$KERNEL_VERSION" | grep -oP '^Boot\K[0-9A-Fa-f]{4}' | head -1)
[[ -n "$num" ]] || exit 0

order=$(efibootmgr | awk -F'BootOrder: ' '/^BootOrder:/ {print $2}')
[[ -n "$order" ]] || exit 0

neworder="$num"
IFS=',' read -ra items <<< "$order"
for i in "${items[@]}"; do
    [[ "${i^^}" == "${num^^}" ]] && continue
    neworder="$neworder,$i"
done

efibootmgr -o "$neworder" >/dev/null 2>&1 || true
PLUGIN

    chmod 0755 "$plugin"

    # Apply immediately to the newest currently-installed kernel so this VM
    # boots correctly on next reboot without waiting for an upgrade.
    local newest
    newest=$(ls -1 /boot/efi/EFI/Linux/*.efi 2>/dev/null \
        | sed -E 's#.*/[0-9a-f]+-##; s#\.efi$##' \
        | sort -V | tail -1 || true)

    if [[ -n "${newest:-}" ]]; then
        log "Promoting newest installed kernel: ${newest}"
        "$plugin" add "$newest" || warn "Reorder for ${newest} did not apply."
    else
        warn "No UKIs found in /boot/efi/EFI/Linux/ to promote."
    fi

    log "Current BootOrder:"
    efibootmgr | grep -E 'BootOrder|Boot[0-9A-F]{4}\*' || true
}

# =============================================================================
# MODE 2 (OPT-IN): systemd-boot
# =============================================================================
install_systemd_boot() {
    warn "systemd-boot mode selected (USE_SYSTEMD_BOOT=1)."

    if echo "$SB_STATE" | grep -qi enabled; then
        die "Secure Boot is ENABLED. Unsigned systemd-boot may make the VM \
unbootable. Disable Secure Boot in firmware first, or use the default \
(reorder-plugin) mode."
    fi

    log "Installing systemd-boot-unsigned"
    dnf install -y systemd-boot-unsigned

    log "Installing bootloader to ESP (bootctl install)"
    bootctl install

    # Give a recovery menu (VM firmware has none).
    install -d -m 0755 /boot/efi/loader
    if [[ -f /boot/efi/loader/loader.conf ]] && grep -q '^timeout' /boot/efi/loader/loader.conf; then
        sed -i 's/^timeout.*/timeout 5/' /boot/efi/loader/loader.conf
    else
        echo "timeout 5" >> /boot/efi/loader/loader.conf
    fi

    # Ensure Linux Boot Manager is first.
    local lbm order
    lbm=$(efibootmgr | grep -i 'Linux Boot Manager' | grep -oP '^Boot\K[0-9A-Fa-f]{4}' | head -1)
    if [[ -n "$lbm" ]]; then
        order=$(efibootmgr | awk -F'BootOrder: ' '/^BootOrder:/ {print $2}')
        neworder="$lbm"
        IFS=',' read -ra items <<< "$order"
        for i in "${items[@]}"; do
            [[ "${i^^}" == "${lbm^^}" ]] && continue
            neworder="$neworder,$i"
        done
        efibootmgr -o "$neworder" >/dev/null
    fi

    systemctl enable systemd-boot-update.service 2>/dev/null || true

    log "systemd-boot installed. Discovered kernels:"
    bootctl list 2>/dev/null || true
}

# --- Main --------------------------------------------------------------------
if [[ "$USE_SYSTEMD_BOOT" == "1" ]]; then
    install_systemd_boot
else
    install_reorder_plugin
fi

log "Done. Reboot to boot the newest kernel: sudo reboot"
log "After reboot verify with: uname -r"
