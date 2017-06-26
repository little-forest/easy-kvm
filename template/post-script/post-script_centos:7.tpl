###############################################################################
# Packages
%packages
@core
%end

%post --interpreter /bin/bash
# Install EPEL
/bin/rpm -ivh http://ftp.iij.ad.jp/pub/linux/fedora/epel/7/x86_64/e/epel-release-7-9.noarch.rpm

# Install packages
/usr/bin/yum install -y --nogpgcheck vim wget nkf dstat bzip2 pigz

###############################################################################
# /etc/profile

/bin/cat << 'EOC' >> /etc/profile
#------------------------------------------------------------------------------
# Prompt setting
#------------------------------------------------------------------------------
if [ "$UID" -eq 0 ]; then
  # for root
  PS1="\[\033[0;33m\][\u@\h \W]\\$\[\033[0m\] "; export PS1
else
  PS1="\[\033[0;32m\][\u@\h \W]\\$\[\033[0m\] "; export PS1
fi
eval `dircolors -b /etc/DIR_COLORS`

#------------------------------------------------------------------------------
# aliases
#------------------------------------------------------------------------------
alias vir='/usr/bin/vim -R'

#------------------------------------------------------------------------------
# Editor setting
#------------------------------------------------------------------------------
EDITOR=/usr/bin/vim; export EDITOR
EOC

###############################################################################
# /root/.bash_profile
/bin/cat << 'EOC' >> /root/.bash_profile
PATH=$PATH:/usr/local/scripts
export PATH
EOC

###############################################################################
# /root/.bashrc
/bin/cat << 'EOC' >> /root/.bashrc
alias vi='vim'

HISTTIMEFORMAT='%Y-%m-%d %T '; export HISTTIMEFORMAT
EOC

###############################################################################
# /etc/rc.local
/bin/cat << 'EOC' >> /etc/rc.local

# Suppress display power management
#setterm -blank 0 -powersave off -powerdown off

# Disable flow control
stty -ixon
EOC

###############################################################################
# /root/.inputrc
/bin/cat << 'EOC' >> /etc/.inputrc.custom

# Key Customize for history search
"\C-n":history-search-forward
"\C-p":history-search-backward

"\C-b":backward-word
"\C-f":forward-word
EOC
/bin/ln -s /etc/.inputrc.custom /root/.inputrc

###############################################################################
# NTP Setting for CentOS 7
/usr/bin/yum install -y --nogpgcheck chrony
/usr/bin/systemctl start chronyd
/usr/bin/systemctl enable chronyd

#/bin/sed -e 's/^server /#server /' -i /etc/ntp.conf
#/bin/cat << 'EOC' >> /etc/ntp.conf
#server -4 ntp.nict.jp
#server -4 ntp1.jst.mfeed.ad.jp
#server -4 ntp2.jst.mfeed.ad.jp
#server -4 ntp3.jst.mfeed.ad.jp
#EOC
#
#/usr/sbin/ntpdate -4 -d ntp.nict.jp
#/sbin/chkconfig ntpd on
#/sbin/service ntpd start

#%%INCLUDE%%

###############################################################################
# update all packages (It will take a long time)
# /usr/bin/yum update -y --nogpgcheck

%end

reboot
