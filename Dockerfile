FROM alpine:3.5
MAINTAINER Jon Schulberger <jschoulzy@gmail.com>

# Arg defaults
ARG VUSER=ftpuser
ARG VPASS=ftpuser
ARG VGRP=ftpgroup
ARG port_ftp_data=20
ARG port_ftp_ctrl=21
ARG port_ftps_imp=990
ARG pasv_enable=NO
ARG port_pasv_min=0
ARG port_pasv_max=0
ARG pasv_addr_resolve=YES
ARG pasv_addr=ftp.mysite.com
ARG ssl_enable=NO
ARG rsa_cert=/etc/ssl-certs/vsftpd.pem
ARG rsa_key=/etc/ssl-certs/vsftpd.pem
ARG custom_conf=false
ARG custom_conf_loc=

# Env vals
ENV VUSER=${VUSER} \
    VPASS=${VPASS} \
    VGRP=${VGRP} \
    port_ftp_data=${port_ftp_data} \
    port_ftp_ctrl=${port_ftp_ctrl} \
    port_ftps_imp=${port_ftps_imp} \
    pasv_enable=${pasv_enable} \
    port_pasv_min=${port_pasv_min} \
    port_pasv_max=${port_pasv_max} \
    pasv_addr_resolve=${pasv_addr_resolve} \
    pasv_addr=${pasv_addr} \
    ssl_enable=${ssl_enable} \
    rsa_cert=${rsa_cert} \
    rsa_key=${rsa_key} \
    custom_conf=${custom_conf} \
    custom_conf_loc=${custom_conf_loc} \
    default_conf_loc=/etc/vsftpd/vsftpd.conf

# Make sure the required ports are available
EXPOSE ${port_ftp_data} ${port_ftp_ctrl} ${port_ftps_imp} \
       ${port_pasv_min}-${port_pasv_max}

# Install vsftpd and create required files
RUN apk add --no-cache \
    vsftpd

# Move init script over
COPY vsftpd_init.sh /vsftpd_init.sh

# Enforce permissions on home directory and init script
RUN chmod a+x /vsftpd_init.sh

CMD ["/vsftpd_init.sh"]
