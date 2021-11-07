# version=RHEL8

# System authorization information
auth --enableshadow --passalgo=sha512

# Install OS instead of upgrade
install

# Use network installation
#url --url %{OS_LOCATION}
#cdrom

# Use text mode install
text

# Firewall configuration
firewall --enabled --trust=eth0 --service=ssh

# Keyboard layouts
keyboard --vckeymap=jp106 --xlayouts='jp'

# System language
lang ja_JP.UTF-8

# Network information
#  --device=link ... specifies the first interface with its link in the up state
network  --bootproto=static --device=link --hostname=%{HOST_NAME} --ip=%{IP_ADDR} --gateway=%{GATEWAY} --nameserver=%{NS} --netmask=%{NET_MASK}

# Root password
rootpw rootpass

# SELinux configuration
selinux --disabled

# Do not configure the X Window System
skipx

# System timezone
timezone Asia/Tokyo --isUtc

zerombr
clearpart --linux --drives=vda
part /boot --fstype=xfs --size=%{BOOT_PARTITION_SIZE}
part pv.01 --grow --size=1

volgroup centos --pesize=4096 pv.01
logvol / --fstype=xfs --name=centos_root --vgname=centos --grow --size=1024 --maxsize=%{DISK_SIZE}
logvol swap --name=centos_swap --vgname=centos --size=%{SWAP_SIZE}

#===========================================================
# Post scripts
#===========================================================
