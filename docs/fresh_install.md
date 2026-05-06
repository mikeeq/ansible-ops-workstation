# Fresh install

1. Set hostname

   ```
   hostnamectl hostname mikeePC
   ```

2. Update OS:

   ```
   dnf upgrade --refresh -y
   ```

3. Reboot

4. Install t2linux packages

   ```
   sudo dnf copr enable sharpenedblade/t2linux
   sudo dnf swap --from-repo="copr:copr.fedorainfracloud.org:sharpenedblade:t2linux" kernel kernel
   sudo dnf install t2linux-release
   ```

5. Touchbar setup

   ```
   cp -rfv /usr/share/tiny-dfr/config.toml /etc/tiny-dfr/config.toml

   vi /etc/tiny-dfr/config.toml
   ###
   MediaLayerDefault = true
   ###
   ```

6. Setup keyboard:

   ```
   vi /etc/modprobe.d/hid_apple.conf
   ###
   options hid_apple swap_fn_leftctrl=1
   options hid_apple swap_opt_cmd=1
   ###
   dracut -f
   ```

7. Reboot

8. Remove old (stock) kernels

   ```
   sudo dnf5 remove --oldinstallonly --setopt installonly_limit=1
   ```


7. Install mise and activate

   ```
   curl https://mise.run | sh
   echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
   echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
   ```

8. Clone repository

   ```bash
   # Create directory for github repository
   mkdir -p ~/git/github
   cd ~/git/github

   # Clone (pull) git repository
   git clone https://github.com/mikeeq/ansible-ops-workstation.git
   ```

9. Reboot

10. Go to power settings, disable automatic suspend
11. Disable suspend on power button, display lid

## Main issues with F44

Wayland clipboard sync doesn't work:
   - https://github.com/flatpak/libportal/pull/214
   - https://github.com/deskflow/deskflow/pull/9415
   - https://github.com/deskflow/deskflow/pull/9431
