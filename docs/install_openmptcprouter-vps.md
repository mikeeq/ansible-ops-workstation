curl -L https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2 -O

create the vm via virt-manager, make it uefi, only one nic - macvtap interface and disable secureboot

 <os firmware="efi">
    <type arch="x86_64" machine="pc-q35-rhel9.8.0">hvm</type>
    <firmware>
      <feature enabled="no" name="enrolled-keys"/>
      <feature enabled="no" name="secure-boot"/>
    </firmware>
    <loader readonly="yes" secure="no" type="pflash" format="raw">/usr/share/edk2/ovmf/OVMF_CODE.fd</loader>
    <nvram template="/usr/share/edk2/ovmf/OVMF_VARS.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/debian12_VARS.fd</nvram>
    <boot dev="hd"/>
  </os>

dnf install libguestfs-tools guestfs-tools

virt-customize -a debian-12-nocloud-amd64.qcow2 --root-password password:test
qemu-img resize debian-12-nocloud-amd64.qcow2 +15G

virsh start debian12
virsh console debian12

passwd

apt-get update
apt-get -y install e2fsprogs cloud-guest-utils vim wget curl screen linux-sysctl-defaults procps
apt-get install -y ca-certificates && sed -i '/^mozilla\/DST_Root_CA_X3/s/^/!/' /etc/ca-certificates.conf && update-ca-certificates -f

growpart /dev/vda 1
resize2fs /dev/vda1

reboot

When IPv6 is disabled using /etc/sysctl.conf

net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
net.ipv6.conf.enp7s0.disable_ipv6=1

sysctl -p

Locate the GRUB_CMDLINE_LINUX line and add ipv6.disable=1 to it. (e.g., GRUB_CMDLINE_LINUX="quiet splash ipv6.disable=1")Update GRUB and reboot your system:bash

apt-get upgrade -y
reboot

curl -6 https://ifconfig.co

curl https://www.openmptcprouter.com/server/debian-x86_64.sh -O

# fix
	if [ "$VERSION_ID" = "13" ] && [ "$ID" = "debian" ]; then
		apt-get -y --allow-downgrades install openvpn easy-rsa
	else
		apt-get -y --default-release install openvpn easy-rsa
	fi
## by
	if [ "$VERSION_ID" = "13" ] && [ "$ID" = "debian" ]; then
		apt-get -y --allow-downgrades install openvpn easy-rsa
	fi

screen -S miki
UPDATE_OS=no FORCE_UPDATE_OS=no KERNEL="6.12" sh debian-x86_64.sh

###
curl -L https://cloud.debian.org/images/cloud/trixie/latest/debian-13-nocloud-amd64.qcow2 -O

qemu-img resize debian-13-nocloud-amd64.qcow2 +15G

passwd

apt-get update
apt-get -y install e2fsprogs cloud-guest-utils vim wget curl screen
apt-get install -y ca-certificates && sed -i '/^mozilla\/DST_Root_CA_X3/s/^/!/' /etc/ca-certificates.conf && update-ca-certificates -f

growpart /dev/vda 1
resize2fs /dev/vda1

Locate the GRUB_CMDLINE_LINUX line and add ipv6.disable=1 to it. (e.g., GRUB_CMDLINE_LINUX="quiet splash ipv6.disable=1")Update GRUB and reboot your system:bash

reboot

curl -6 https://ifconfig.co
apt-get upgrade -y
reboot

curl https://www.openmptcprouter.com/server/debian-x86_64.sh -O
sh debian-x86_64.sh

###

qemu-img convert -f vdi openmptcprouter-v0.63-6.12-r0+30806-070d8eb4d5-x86-64-generic-ext4-combined-efi.vdi openmptcprouter-v0.63-6.12-r0+30806-070d8eb4d5-x86-64-generic-ext4-combined-efi.qcow2
passwd

change eth ip address

vi /etc/config/network

disable dhcp
Network -> DHCP and DNS -> Authoritative
Network -> Interfaces -> Lan -> DHCP Server -> Ignore interface


### ubuntu - only works on 22.04

apt-get update
apt-get -y install e2fsprogs cloud-guest-utils vim wget curl screen
apt-get install -y ca-certificates && sed -i '/^mozilla\/DST_Root_CA_X3/s/^/!/' /etc/ca-certificates.conf && update-ca-certificates -f

Locate the GRUB_CMDLINE_LINUX line and add ipv6.disable=1 to it. (e.g., GRUB_CMDLINE_LINUX="quiet splash ipv6.disable=1")Update GRUB and reboot your system:bash

apt-get upgrade -y
reboot

curl https://www.openmptcprouter.com/server/debian-x86_64.sh -O
sh debian-x86_64.sh

UPDATE_OS=no FORCE_UPDATE_OS=no sh debian-x86_64.sh
