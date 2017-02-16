#!/bin/sh

set -e

# Make sure user exists
id -u ${VUSER} &>/dev/null || adduser ${VUSER} -D

# Enforce password
echo "${VUSER}:${VPASS}" | chpasswd

# Make sure group exists
id -u ${VGRP} &>/dev/null || addgroup ${VGRP}

# Make sure folder exists for vsftpd
mkdir -p /var/run/vsftpd/empty

# Enforce single user login for ftp(s)
echo ${VUSER} > /etc/vsftpd/vsftpd.userlist

# Enforce permissions on directories
chmod u=rx,g=rx,o=rx /home/${VUSER}
chown -R ${VUSER}:${VGRP} /home/${VUSER}

# Enforce config settings for vsftpd
# TODO: use all ftp ports
printf \
"seccomp_sandbox=NO\n
listen=YES\n
listen_ipv6=NO\n
pasv_enable=YES\n" 
pasv_address=${pasv_addr}\n
pasv_addr_resolve=YES\n
anonymous_enable=NO\n
local_enable=YES\n
write_enable=YES\n
dirmessage_enable=NO\n
use_localtime=YES\n
xferlog_enable=YES\n
connect_from_port_20=YES\n
ascii_upload_enable=YES\n
ascii_download_enable=YES\n
chroot_local_user=YES\n
userlist_deny=NO\n
userlist_enable=YES\n
userlist_file=/etc/vsftpd/vsftpd.userlist\n
secure_chroot_dir=/var/run/vsftpd/empty\n
pam_service_name=vsftpd\n
rsa_cert_file=${rsa_cert}\n
rsa_private_key_file=${rsa_key}\n
ssl_enable=YES\n
force_local_data_ssl=NO\n
force_local_logins_ssl=NO\n
ssl_tlsv1=YES\n
ssl_sslv2=NO\n
ssl_sslv3=NO\n
ssl_ciphers=HIGH\n"

# Enforce environment variables in config
printf \
"pasv_min_port=${port_pasv_min}\n
pasv_max_port=${port_pasv_max}\n"

# Start vsftpd
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
