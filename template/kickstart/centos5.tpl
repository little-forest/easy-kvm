# version=RHEL5

# System authorization information
auth --enableshadow --passalgo=sha512

# Install OS instead of upgrade
install

# Use network installation
#url --url="%{OS_LOCATION}"
#cdrom

# Use text mode install
text

# Firewall configuration
firewall --enabled --port=22:tcp

# Keyboard layouts
keyboard jp106

# System language
lang ja_JP.UTF-8
langsupport --default=ja_JP.UTF-8 ja_JP.UTF-8

# Network information
network  --bootproto=static --device=eth0 --hostname=%{HOST_NAME} --ip=%{IP_ADDR} --gateway=%{GATEWAY} --nameserver=%{NS} --netmask=%{NET_MASK}

# Root password
rootpw rootpass

# SELinux configuration
selinux --disabled

# Do not configure the X Window System
skipx

# System timezone
timezone --utc Asia/Tokyo

# Disk partition
bootloader --location=mbr --driveorder=vda --append="console=ttyS0,115200n8"
clearpart --all --initlabel --linux --drives=vda
part /boot --fstype ext3 --size=100 --ondisk=vda
part swap --size=256
part / --fstype ext3 --size=100 --grow

reboot

#===========================================================
# Post scripts
#===========================================================
