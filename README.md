<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** mikeeq, ansible-ops-workstation, twitter_handle, email, ansible-ops-workstation, project_description
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/mikeeq/ansible-ops-workstation">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Ansible_logo.svg/1664px-Ansible_logo.svg.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">ansible-ops-workstation</h3>

  <p align="center">
    Ansible playbooks for provisioning Fedora Workstations with tools which are commonly used in DevOps environments.
    <br />
    <a href="https://github.com/mikeeq/ansible-ops-workstation"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/mikeeq/ansible-ops-workstation">View Demo</a>
    ·
    <a href="https://github.com/mikeeq/ansible-ops-workstation/issues">Report Bug</a>
    ·
    <a href="https://github.com/mikeeq/ansible-ops-workstation/issues">Request Feature</a>
  </p>
</p>

[![CI](https://github.com/mikeeq/ansible-ops-workstation/actions/workflows/ci.yaml/badge.svg)](https://github.com/mikeeq/ansible-ops-workstation/actions/workflows/ci.yaml)

[![CircleCI](https://circleci.com/gh/mikeeq/ansible-ops-workstation.svg?style=svg)](https://circleci.com/gh/mikeeq/ansible-ops-workstation)

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <!-- <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li> -->
    <li><a href="#usage">Usage</a></li>
    <!-- <li><a href="#roadmap">Roadmap</a></li> -->
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

Ansible playbooks for provisioning Fedora Workstations with tools which are commonly used in DevOps environments.

### Built With

- [Ansible](https://github.com/ansible/ansible)

<!-- GETTING STARTED -->
<!-- ## Getting Started -->

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- USAGE EXAMPLES -->
## Usage

### Fedora

1. Install git, python, ansible

   ```bash
   sudo -i
   dnf install -y git python3-pip curl sudo
   pip3 install ansible
   ```

2. Clone repository

   ```bash
   # Create directory for github repository
   mkdir -p ~/git/github
   cd ~/git/github

   # Clone (pull) git repository
   git clone https://github.com/mikeeq/ansible-ops-workstation.git
   ```

3. Change `user_name` in `playbooks/group_vars/all.yaml` to your Fedora username and run Ansible

   ```bash
   # Go to repository directory
   cd ansible-ops-workstation/playbooks

   # Edit playbooks/group_vars/all.yaml, change user_name
   vi group_vars/all.yaml

   # Run Ansible
   ansible-playbook -i ../inventory/hosts.yaml fedora.yaml -K
   ```

4. Reboot your machine to apply all changes

#### Optional

1. Open terminal, login as root, upgrade your OS:

   ```bash
   sudo -i
   hostnamectl set-hostname mikeePC
   dnf upgrade -y
   ```

2. Reboot your machine

   ```bash
   reboot
   ```

### Ubuntu WSL

1. Install

   - VSCode - <https://code.visualstudio.com/download>
   - Ubuntu 24.04 WSL2
     - <https://apps.microsoft.com/store/detail/windows-subsystem-for-linux/9P9TQF7MRM4R>
     - <https://apps.microsoft.com/detail/9nz3klhxdjp5?hl=en-gb&gl=PL>
     - <https://docs.microsoft.com/en-us/windows/wsl/install>
   - Docker Desktop for Windows - <https://docs.docker.com/desktop/windows/install/>
   - Windows Terminal
     - <https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab>
     - <https://github.com/microsoft/terminal>

2. Open WSL2 terminal, login as root, upgrade your OS:

   ```bash
   sudo -i
   apt-get update
   apt-get upgrade
   ```

3. Install git, python, ansible

   ```bash
   sudo -i
   apt-get install -y git python3-pip curl sudo
   pip3 install --break-system-packages ansible
   ```

4. Clone repository

   ```bash
   # Create directory for github repository
   mkdir -p ~/git/github
   cd ~/git/github

   # Clone (pull) git repository
   git clone https://github.com/mikeeq/ansible-ops-workstation.git
   ```

5. Change `user_name` in `playbooks/group_vars/all.yaml` to your WSL username ([link](https://github.com/mikeeq/ansible-ops-workstation/blob/main/playbooks/group_vars/all.yaml#L2)) and run Ansible

   ```bash
   # Go to repository directory
   cd ansible-ops-workstation/playbooks

   # Edit playbooks/group_vars/all.yaml, change user_name
   vi group_vars/all.yaml

   # Run Ansible
   ansible-playbook -i ../inventory/hosts.yaml wsl-ubuntu.yaml -K
   ```

6. Install PowerLevel10K font on Windows - <https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf>

7. Copy Windows Terminal config from - <https://github.com/mikeeq/ansible-ops-workstation/blob/main/roles/desktop/machines/wsl/templates/settings.json>

   - and paste it here - `C:\Users\${WINDOWS_USER_NAME}\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState`

8. Copy VScode config file from - <https://github.com/mikeeq/ansible-ops-workstation/blob/main/roles/desktop/apps/vscode/files/settings.json>

   - and paste it here - `C:/Users/${WINDOWS_USER_NAME}/AppData/Roaming/Code/User/settings.json`

9. You can also install VScode extensions manually from the list here - <https://github.com/mikeeq/ansible-ops-workstation/blob/main/playbooks/group_vars/all.yaml#L146-L173>, by finding them in the VScode UI and clicking install or via CLI by executing:

   ```bash
   code --install-extension ${EXTENSION_NAME}
   ```

10. Restart your VScode/Windows Terminal to see your new oh-my-zsh :)

> Remember to use VScode with Remote WSL extension and store all your unix/git files/repositories under WSL2 to not encounter any issues with file permissions, etc.
>> I also recommend to use builtin terminal in VSCode as it also really configurable and works like a charm with oh-my-zsh and P10K

- ms-vscode-remote.remote-wsl - <https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl>

## Tips and Tricks

1. MacOS disk utility doesn't show free space on a harddisk

   - create ntfs partition on any free disk space on that disk, then shrink/resize your APFS partitions/containers.

2. To fix Docker on newer Fedora's installations:

   ```bash
   vi /etc/default/grub
     systemd.unified_cgroup_hierarchy=0
   grub2-mkconfig -o /boot/grub2/grub.cfg
   ```

3. Fix selinux policies for OpenVPN certs custom path

   ```bash
   sudo semanage fcontext -a -t home_cert_t /home/mikee/Documents/vpns/certs_vpn/ca.crt
   sudo restorecon -R -v /home/mikee/Documents/vpns/certs_vpn/
   ```

4. How to enable bitlocker on macbook

   - Configure BitLocker to work without a TPM:

     ```bash
     Start => run => gpedit.msc
     Open the Local Computer Policy node
     Navigate to Computer Configuration \ Administrative Templates \ Windows
     Components \ Bit Locker Drive Encryption \ Operating System Drives
     Double click on Require additional authentication at startup
     Enable the feature and check the box next to `Allow BitLocker without a compatible TPM`, click Apply and Ok, and close out of Local Group Policy Editor.
     ```

5. To save last boot entry in grub - add lines below to `/etc/default/grub` and run `grub2-mkconfig -o /boot/grub2/grub.cfg`

   ```bash
   GRUB_DEFAULT=saved
   GRUB_SAVEDEFAULT=true
   ```

6. To setup hp printer

   ```bash
   hp-setup        # to configure HP printer
   ```

7. To disable KDE wallet when using pip3

   ```bash
   python3 -m keyring --disable
   ```

8. hid_apple mods - <https://github.com/free5lot/hid-apple-patched>

   ```bash
   cd /sys/module/hid_apple/parameters
   echo 1 > swap_fn_leftctrl
   echo 1 > swap_opt_cmd
   ```

   ```bash
   # vi /etc/modprobe.d/hid_apple.conf
   options hid_apple swap_fn_leftctrl=1
   options hid_apple swap_opt_cmd=1
   options hid_apple iso_layout=1

   # after adding this options to the file, you need to rebuild your initramfs
   ## in Fedora
   dracut -f
   ```

9. Add SSH keys, config and private gpg keys from keybase

   ```bash
   keybase pgp list
   keybase pgp export --query $KEY_ID -s > private.gpg; gpg --import private.gpg; rm -v private.gpg
   keybase pgp export --query $KEY_ID > public.gpg; gpg --import public.gpg; rm -v public.gpg
   git-crypt add-gpg-user -n --trusted $USER_ID[could be email]

   # If `gpg -vvvvv --import` hangs on:
   ## gpg: waiting for lock (held by 5555) ...
   ## gpg: no running keyboxd - starting '/usr/libexec/keyboxd'
   ### you can fix it by commenting out use-keyboxd in ~/.gnupg/common.conf.
   ```

10. To save HTTPS git credentials

    ```bash
    git config --global credential.helper store
    git config lfs.cachecredentials true
    ```

11. How to install latest NVIDIA driver on Linux:

    - Fedora 36 issues with NVIDIA driver
      - <https://github.com/NVIDIA/open-gpu-kernel-modules/issues/228>
      - <https://www.if-not-true-then-false.com/2015/fedora-nvidia-guide/>

    ```bash
    ### Install using .run installer (manually) ###
    # Install DKMS to automatically install Nvidia driver when updating kernel
    dnf install dkms kernel-devel kernel-headers gcc make acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig vdpauinfo libva-vdpau-driver libva-utils

    # Add opensource nvidia driver - nouveau to blacklist
    vi /etc/modprobe.d/nvidia-installer-disable-nouveau.conf

    blacklist nouveau
    options nouveau modeset=0

    vi /etc/default/grub

    GRUB_CMDLINE_LINUX="rhgb quiet rd.driver.blacklist=nouveau"

    grub2-mkconfig -o /boot/grub2/grub.cfg

    # Rebuild initramfs
    dracut -f

    systemctl set-default multi-user.target

    reboot

    # Download latest cuda driver and nvidia driver and go to download path
    # CUDA - https://developer.nvidia.com/cuda-downloads
    bash cuda_11.5.1_495.29.05_linux.run
    # cuda will also install nvidia driver, but in older version
    # Nvidia driver - https://www.nvidia.com/en-us/drivers/unix/
    bash NVIDIA-Linux-x86_64-495.46.run

    systemctl set-default graphical.target

    dnf remove xorg-x11-drv-nouveau

    reboot

    # to dynamically change current session to non-graphical user interface
    systemctl isolate multi-user.target
    # to revert back to graphical
    systemctl isolate graphical.target

    # If there are some issues with booting to graphical environment, i.e.: with API mismatch error, execute `dracut -f` to rebuild initramfs with newer version of driver
    # dmesg|grep -i nvrm -A3
    # [  113.647054] NVRM: API mismatch: the client has the version 460.91.03, but
    #                NVRM: this kernel module has the version 390.144.  Please
    #                NVRM: make sure that this kernel module and all NVIDIA driver
    #                NVRM: components have the same version.
    dracut -f

    # If you fail to boot to Fedora, you can edit boot entry in grub by clicking "e" in grub bootmenu and in line starting with "linux ..." add at the end "init 3" to boot in multi-user.target (without graphical interface)

    # If you are using Secure Boot, during installation of the NVIDIA drivers create new key pair (or use existing one), and if it's a new key pair then add them to UEFI key by executing

    mkdir -p /usr/share/uefimok/
    cp -rfv /usr/share/nvidia/nvidia-modsign-crt-${id}.der /usr/share/uefimok/
    cp -rfv /usr/share/nvidia/nvidia-modsign-key-${id}.key /usr/share/uefimok/

    mokutil --import /usr/share/uefimok/nvidia-modsign-crt-${id}.der

    bash NVIDIA-Linux-x86_64-550.107.02.run --module-signing-secret-key=/usr/share/uefimok/nvidia-modsign-key-${id}.key --module-signing-public-key=/usr/share/uefimok/nvidia-modsign-crt-${id}.der

    ### Install using packages from CUDA rpm repository ###

    # Check latest available rpm repo (fedora40 is not available) - https://developer.download.nvidia.com/compute/cuda/repos/
    distro=fedora39

    dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/$distro/x86_64/cuda-$distro.repo
    dnf -y install dkms
    dnf -y module install nvidia-driver:open-dkms
    dnf -y install nvidia-container-toolkit

    # Make sure you're running desktop in X11 mode, wayland is a bit laggy still
    # xorg.conf can be generated from nvidia-settings

    # Enroll MOK key if you're using SecureBoot
    ## You can check by which key the kernel module is signed by, by executing: modinfo nvidia-drm, and then try to find it locally (i.e.: in dkms config file)
    mokutil --import /var/lib/dkms/mok.pub

    ### Enabling wayland

    ## vi /etc/dracut.conf.d/nvidia.conf
    force_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "

    ## vi /etc/modprobe.d/nvidia.conf
    options nvidia_drm modeset=1 fbdev=1

    ##

    mv /usr/lib/udev/rules.d/61-gdm.rules /root/61-gdm.rules
    dracut -f

    ```

12. To fix purple'ish screen, enable OC and Fan control (I recommend to use GreenWithEnvy - gwe (installed using flatpak)) apply those changes to `/etc/X11/xorg.conf`:

    ```bash
    Section "Device"
        # To fix ddcutil
        Option         "RegistryDwords" "RMUseSwI2c=0x01; RMI2cSpeed=100"
        # To enable fan control and OC
        Option         "Coolbits" "12"
    EndSection

    Section "Screen"
        # To fix purple'ish screen
        ## These settings can be controled using nvidia-settings --> X Server Display Configuration --> Advanced... --> Force Composition Pipeline --> Save to X Configuration File
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, AllowGSYNCCompatible=On}"
    EndSection

    ### Example /etc/X11/xorg.conf
    Section "Device"
        Identifier     "Device0"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"
        BoardName      "NVIDIA GeForce RTX 3070"
        Option         "RegistryDwords" "RMUseSwI2c=0x01; RMI2cSpeed=100"
        Option         "Coolbits" "12"
    EndSection

    Section "Screen"
        Identifier     "Screen0"
        Device         "Device0"
        Monitor        "Monitor0"
        DefaultDepth    24
        Option         "Stereo" "0"
        Option         "nvidiaXineramaInfoOrder" "DFP-1"
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, AllowGSYNCCompatible=On}"
        Option         "SLI" "Off"
        Option         "MultiGPU" "Off"
        Option         "BaseMosaic" "off"
        SubSection     "Display"
            Depth       24
        EndSubSection
    EndSection
    ```

13. To enable "outdated" gnome extension add used gnome-shell version to `shell-version` table in `metadata.json` extension's file

    ```bash
    gnome-shell --version
    GNOME Shell 41.2

    EXTENSION_NAME=cpufreq@konkor
    vi ~/.local/share/gnome-shell/extensions/${EXTENSION_NAME}/metadata.json

    {
      "shell-version": [
        "41.2
      ]
    }
    ```

14. To turn off hdd

    ```bash
    echo 1 > /sys/block/sdb/device/delete
    ```

15. To open remote VScode session from CLI:

    ```bash
    code --folder-uri vscode-remote://ssh-remote+${SSH_USER}@${HOST}${PATH}

    # Example
    code --folder-uri vscode-remote://ssh-remote+user@192.168.1.10/home/user/git
    ```

16. To change brightness:

```
cat /sys/class/backlight/acpi_video0/max_brightness
echo 2 > /sys/class/backlight/acpi_video0/brightness
```

17. To give Steam access to local storage outside of flatpak

```
flatpak override com.valvesoftware.Steam --filesystem=${PATH_TO_FILESYSTEM}

## If your games don't load/start and those are stored on NTFS
# NTFS mount needs to be done as user
# https://github.com/ValveSoftware/Proton/wiki/Using-a-NTFS-disk-with-Linux-and-Windows#editing-fstab

## cat /etc/fstab
/dev/nvme1n1p2 /mnt/dntfs auto uid=1000,gid=1000,rw,user,exec,umask=000 0 0

### only worked after reboot, CLI commands with the same options passed didn't work (still NTFS was mounted as root), i.e.
❯ mount.ntfs-3g -o uid=1000,gid=1000,dmask=0022,fmask=0133 /dev/nvme1n1p2 /mnt/dntfs
```

18. Terminator fails to open with an error `terminator:24:<module>:ModuleNotFoundError: No module named 'psutil'`, try reinstalling `dnf reinstall python3-psutil` to fix it

19. Enable tabs scrolling in firefox:

```
### about:config

# tabs mouse scrolling
toolkit.tabbox.switchByScrolling = true

# if google docs crashes, page jumps
gfx.canvas.accelerated = false
```

20. On Fedora 41 or newer, when connection Azure DevOps or GitHub over SSH fails with an error:

```
ssh_dispatch_run_fatal: Connection to 40.74.28.12 port 22: error in libcrypto
```

It needs to be fixed by executing `update-crypto-policies --set LEGACY` (or creating your own custom crypto policy) and rebooting the machine.

21. ssh-config for Azure DevOps and GitHub:

```
Host ssh.dev.azure.com
  HostName ssh.dev.azure.com
  User git
  Port 22
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes
  PubkeyAcceptedKeyTypes=ssh-rsa
  HostKeyAlgorithms=+ssh-rsa

Host vs-ssh.visualstudio.com
  HostName vs-ssh.visualstudio.com
  User git
  Port 22
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes
  PubkeyAcceptedKeyTypes=ssh-rsa
  HostKeyAlgorithms=+ssh-rsa

Host github.com
  HostName github.com
  User git
  Port 22
  IdentityFile ~/.ssh/id_rsa
  IdentitiesOnly yes
```

22. AMD Radeon overdrive/overclocking:

```
dnf install hipblas rocminfo amd-gpu-firmware amd-ucode-firmware xorg-x11-drv-amdgpu amdsmi

grubby --args="amdgpu.ppfeaturemask=0xffffffff " --update-kernel=ALL
cat /etc/modprobe.d/amd.conf

options amdgpu ppfeaturemask=0xffffffff

echo "s 1 2050" > /sys/module/amdgpu/drivers/pci:amdgpu/0000:03:00.0/pp_od_clk_voltage
echo "294000000" > /sys/module/amdgpu/drivers/pci:amdgpu/0000:03:00.0/hwmon/hwmon2/power1_cap
cat /sys/module/amdgpu/drivers/pci:amdgpu/0000:03:00.0/pp_od_clk_voltage
cat /sys/module/amdgpu/drivers/pci:amdgpu/0000:03:00.0/hwmon/hwmon2/power1_cap
echo "r" > /sys/class/drm/card1/device/pp_od_clk_voltage
```

23. Fedora update/upgrade fails

```
sudo dnf system-upgrade log --number=-1

Mar 11 00:02:38 spud dnf-3[3922]: error: Verifying a signature using certificate E8F23996F23218640CB44CBE75CF5AC418B8E74C (Fedora (39) <fedora-39-primary@fedoraproject.org>):
Mar 11 00:02:38 spud dnf-3[3922]:   Signature bbe9 created at Thu Mar 14 23:19:58 2024 invalid: signature is not alive
Mar 11 00:02:38 spud dnf-3[3922]:       because: Not live until 2024-03-14T23:14:58Z

sudo touch /usr/lib/clock-epoch
```

24. VScode in wayland

```
code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto ~/git
```

25. Citrix

```
/opt/Citrix/ICAClient/wfica -icaroot /opt/Citrix/ICAClient /home/user/Downloads/citrix.ica
```

26. mdadm fix raid

```
# https://unix.stackexchange.com/questions/148062/mdadm-raid-doesnt-mount/149177

cat /proc/mdstat

# stop all mdraids
mdadm --stop /dev/md12[567]

# reassemble
mdadm --assemble --scan --force -v

cat /proc/mdstat
```

27. Image to text

```
dnf install tesseract
tesseract Screenshot\ From\ 2025-05-05\ 11-50-36.png test.txt
```

28. Azure DevOps HTTP auth

```
export accessToken=$(az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query "accessToken" --output tsv)
alias git="git -c http.extraheader=\"AUTHORIZATION: bearer $accessToken\""

```

29. Disable suspend on lid closed

```
cp -rfv /usr/lib/systemd/logind.conf /etc/systemd

vi /etc/systemd/logind.conf
# change the #HandleLidSwitch=suspend line in that file to HandleLidSwitch=ignore.
```

<!-- LICENSE -->
## License

Distributed under the GNU GPLv3 License. See `COPYING` for more information.

<!-- CONTACT -->
## Contact

Twitter - [@mikeeqp](https://twitter.com/mikeeqp)

Project Link: [https://github.com/mikeeq/ansible-ops-workstation](https://github.com/mikeeq/ansible-ops-workstation)

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

- [Best-README-Template](https://raw.githubusercontent.com/othneildrew/Best-README-Template)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/mikeeq/ansible-ops-workstation.svg?style=for-the-badge
[contributors-url]: https://github.com/mikeeq/ansible-ops-workstation/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/mikeeq/ansible-ops-workstation.svg?style=for-the-badge
[forks-url]: https://github.com/mikeeq/ansible-ops-workstation/network/members
[stars-shield]: https://img.shields.io/github/stars/mikeeq/ansible-ops-workstation.svg?style=for-the-badge
[stars-url]: https://github.com/mikeeq/ansible-ops-workstation/stargazers
[issues-shield]: https://img.shields.io/github/issues/mikeeq/ansible-ops-workstation.svg?style=for-the-badge
[issues-url]: https://github.com/mikeeq/ansible-ops-workstation/issues
[license-shield]: https://img.shields.io/github/license/mikeeq/ansible-ops-workstation.svg?style=for-the-badge
[license-url]: https://github.com/mikeeq/ansible-ops-workstation/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/miotkmikolaj/
