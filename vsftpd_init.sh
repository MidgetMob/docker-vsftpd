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

custom_conf=${custom_conf}
ENV custom_conf_loc=${custom_conf}
ENV default_conf_loc=/etc/vsftpd/vsftpd.conf

# Which config should we use?
if [ ${custom_conf} != "true" ] {
  # Enforce config settings for vsftpd
  # TODO: use all ftp ports
  printf \
  "seccomp_sandbox=NO
  \nlisten=YES
  \nlisten_ipv6=NO
  \npasv_enable=YES
  \npasv_min_port=${port_pasv_min}
  \npasv_max_port=${port_pasv_max}
  \npasv_address=${pasv_addr}
  \npasv_addr_resolve=${pasv_addr_resolve}
  \nanonymous_enable=NO
  \nlocal_enable=YES
  \nwrite_enable=YES
  \ndirmessage_enable=NO
  \nuse_localtime=YES
  \nxferlog_enable=YES
  \nconnect_from_port_20=YES
  \nascii_upload_enable=YES\n
  \nascii_download_enable=YES\n
  \nchroot_local_user=YES\n
  \nuserlist_deny=NO\n
  \nuserlist_enable=YES\n
  \nuserlist_file=/etc/vsftpd/vsftpd.userlist\n
  \nsecure_chroot_dir=/var/run/vsftpd/empty\n
  \npam_service_name=vsftpd\n
  \nrsa_cert_file=${rsa_cert}\n
  \nrsa_private_key_file=${rsa_key}\n
  \nssl_enable=YES\n
  \nforce_local_data_ssl=NO\n
  \nforce_local_logins_ssl=NO\n
  \nssl_tlsv1=YES\n
  \nssl_sslv2=NO\n
  \nssl_sslv3=NO\n
  \nssl_ciphers=HIGH" > ${default_conf_loc}
}
# Copy the custom config to the default location
else {
  cp -f ${custom_conf_loc} ${default_conf_loc}
}

# Start vsftpd
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
