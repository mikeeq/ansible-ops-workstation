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
    <img src="https://docs.ansible.com/ansible/latest/_static/images/logo_invert.png" alt="Logo" width="80" height="80">
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
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

-

### Built With

- [Ansible](https://github.com/ansible/ansible)


<!-- GETTING STARTED -->
## Getting Started

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

3. Install git, python, ansible

   ```
   sudo -i
   dnf install -y git python3
   pip3 install ansible
   ```

4. Clone repository and run ansible

   ```bash
   ansible-playbook -K -i inventory/hosts fedora.yml
   ```

5. Reboot your machine

6. hid_apple mods

   ```bash
   cd /sys/module/hid_apple/parameters
   echo 1 > swap_fn_leftctrl
   echo 1 > swap_opt_cmd
   ```

  ```bash
  # vi /etc/modprobe.d/hid_apple.conf
   options hid_apple swap_fn_leftctrl=1
   options hid_apple swap_opt_cmd=1
  #  update_kernel_mbp
  ```

7. Add SSH keys, config and private gpg keys from keybase

   ```bash
   keybase pgp export --query $KEY_ID -s > private.gpg; gpg --import private.gpg; rm -v private.gpg
   ```

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

<!-- LICENSE -->
## License

Distributed under the GNU GPLv3 License. See `COPYING` for more information.

<!-- CONTACT -->
## Contact

Twitter - [@mikeeqp](https://twitter.com/mikeeqp)

Project Link: [https://github.com/mikeeq/ansible-ops-workstation](https://github.com/mikeeq/ansible-ops-workstation)

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [Best-README-Template](https://raw.githubusercontent.com/othneildrew/Best-README-Template)

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
