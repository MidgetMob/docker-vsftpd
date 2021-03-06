#!/bin/sh

set -e

# Make sure user exists
id -u ${VUSER} &>/dev/null || adduser ${VUSER} -D

# Enforce password
echo "${VUSER}:${VPASS}" | chpasswd &> /dev/null

# Make sure group exists
getent group ${VGRP} &> /dev/null || addgroup ${VGRP}

# Make sure folder exists for vsftpd
mkdir -p /var/run/vsftpd/empty

# Enforce single user login for ftp(s)
echo ${VUSER} > /etc/vsftpd/vsftpd.userlist

# Enforce permissions on directories
chmod u=rx,g=rx,o=rx /home/${VUSER}
chown -R ${VUSER}:${VGRP} /home/${VUSER}

# Which config should we use?
if [ "$(echo ${custom_conf} | tr '[:upper:]' '[:lower:]')" != "true" ] || [ ${custom_conf_loc} == "" ]; then
  # Enforce config settings for vsftpd
  # TODO: use all ftp ports
  echo "Setting config values."
  printf \
"seccomp_sandbox=NO
listen=YES
listen_ipv6=NO
pasv_enable=${pasv_enable}
ssl_enable=${ssl_enable}
anonymous_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=NO
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
ascii_upload_enable=YES
ascii_download_enable=YES
chroot_local_user=YES
userlist_deny=NO
userlist_enable=YES
userlist_file=/etc/vsftpd/vsftpd.userlist
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd\n\n" > ${default_conf_loc}

  # Add passive mode vars if necessary
  if [ "$(echo ${pasv_enable} | tr '[:upper:]' '[:lower:]')" == "yes" ]; then
    echo "Enabling passive mode."
    printf \
"pasv_min_port=${port_pasv_min}
pasv_max_port=${port_pasv_max}
pasv_address=${pasv_addr}
pasv_addr_resolve=${pasv_addr_resolve}\n\n" >> ${default_conf_loc}
  fi

  # Add ssl options if necessary
  if [ "$(echo ${ssl_enable} | tr '[:upper:]' '[:lower:]')" == "yes" ]; then
    echo "Enabling SSL."
    printf \
"rsa_cert_file=${rsa_cert}
rsa_private_key_file=${rsa_key}
force_local_data_ssl=NO
force_local_logins_ssl=NO
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
ssl_ciphers=HIGH\n\n" >> ${default_conf_loc}
  fi
# Copy the custom config to the default location
else
  echo "Using custom config at: $custom_conf_loc."
  if [ -f "$custom_conf_loc" ]; then
    cp -f ${custom_conf_loc} ${default_conf_loc}
  else
    echo "Custom config not found. Terminating."
    exit 1
  fi
fi

# Start vsftpd
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
