# prepare chef user
TARGET_USER=chef
TARGET_UID=1000
TARGET_GID=1000
USER_DIR=/home/${TARGET_USER}
USER_SSH_DIR=${USER_DIR}/.ssh

groupadd -g "$TARGET_GID" "$TARGET_USER" 
useradd -u "$TARGET_UID" -c "$TARGET_USER" "$TARGET_USER"

/bin/mkdir ${USER_SSH_DIR}
/bin/chmod 700 ${USER_SSH_DIR}
/bin/touch ${USER_SSH_DIR}/authorized_keys
/bin/chmod 600 ${USER_SSH_DIR}/authorized_keys
/bin/chown -R ${TARGET_USER}.${TARGET_USER} ${USER_SSH_DIR}/

/bin/cat <<EOC > /etc/sudoers.d/${TARGET_USER}
${TARGET_USER} ALL = (ALL) NOPASSWD:ALL
Defaults:${TARGET_USER} !requiretty
EOC

