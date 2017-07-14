######################################################################
# Common post script
######################################################################

#---------------------------------------------------------------------
# prepare maintenance user
#---------------------------------------------------------------------
TARGET_USER=admin
TARGET_GROUP=${TARGET_USER}
TARGET_UID=499
TARGET_GID=499
TARGET_PASSWORD=${TARGET_USER}pass
USER_DIR=/home/${TARGET_USER}
USER_SSH_DIR=${USER_DIR}/.ssh

groupadd -g $TARGET_GID $TARGET_GROUP
useradd -u $TARGET_UID -g $TARGET_GROUP -c 'created by easy-kvm' $TARGET_USER
usermod -a -G wheel $TARGET_USER

/bin/mkdir ${USER_SSH_DIR}
/bin/chmod 700 ${USER_SSH_DIR}
/bin/touch ${USER_SSH_DIR}/authorized_keys
/bin/chmod 600 ${USER_SSH_DIR}/authorized_keys
/bin/chown -R ${TARGET_USER}.${TARGET_USER} ${USER_SSH_DIR}/

/bin/ln -s /etc/.inputrc.custom ${USER_DIR}/.inputrc
/bin/chown -R ${TARGET_USER}:${TARGET_GROUP} ${USER_DIR} 

/bin/cat <<EOS > /etc/sudoers.d/${TARGET_USER}
## Uncomment if you want to use sudo command with no password.
#${TARGET_USER} ALL = (ALL) NOPASSWD:ALL
#Defaults:${TARGET_USER} !requiretty
EOS

# Add SSH public-key
# '%%PUBLIC_KEY%% will be replaced by easy-kvm-create'
/bin/cat <<EOS >> ${USER_SSH_DIR}/authorized_keys
#%%PUBLIC_KEY%%
EOS

# Change password
/bin/cat <<EOS | passwd --stdin ${TARGET_USER}
${TARGET_PASSWORD}
EOS

#---------------------------------------------------------------------
# sshd setting
#---------------------------------------------------------------------
# Disable password authentication
/bin/sed -i -re 's/^(PasswordAuthentication) yes/\1 no/' /etc/ssh/sshd_config

# Forbid root login
/bin/sed -i -re 's/^[ \t]*#?[ \t]*(PermitRootLogin)[ ^t]+(yes|no)/\1 no/' /etc/ssh/sshd_config


/bin/cat << 'EOS' >> /etc/pam.d/sshd
#account required /lib/security/pam_access.so
EOS

/bin/systemctl reload sshd

#---------------------------------------------------------------------
# only wheel group can switch user
#---------------------------------------------------------------------
/bin/cat << 'EOS' >> /etc/login.defs
# only wheel group can switch user
SU_WHEEL_ONLY   yes
EOS

/bin/sed -i -re 's/#(auth[ \t]+required[ \t]+pam_wheel.so[ \t]+use_uid)/\1/' /etc/pam.d/su

