# Fan control
https://github.com/tuxedocomputers/tuxedo-control-center

https://rpm.tuxedocomputers.com/opensuse/15.4/

look out! after disabling fan control in control center, fan control is not being restored to default!

# New tuxedo keyboard doesn't work
https://github.com/tuxedocomputers/tuxedo-keyboard

# fork?
https://github.com/dariost/clevo-xsm-wmi

# working on p170sm
https://bitbucket.org/tuxedocomputers/clevo-xsm-wmi/src

vi /etc/modprobe.d/clevo-xsm-wmi.conf
#options clevo-xsm-wmi kb_color=white,white,white kb_brightness=1
options clevo-xsm-wmi kb_state=0


https://aur.archlinux.org/packages/clevo-xsm-wmi-dkms

hdparm -y /dev/sdc
hdparm -C /dev/sdc
