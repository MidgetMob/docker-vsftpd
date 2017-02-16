FROM alpine:3.5
MAINTAINER Jon Schulberger <jschoulzy@gmail.com>

# Arg defaults
ARG VUSER=deluge
ARG VPASS=deluge
ARG VGRP=deluge
ARG port_ftp_data=20
ARG port_ftp_ctrl=21
ARG port_ftps_imp=990
ARG port_pasv_min=10100
ARG port_pasv_max=10101
ARG pasv_addr_resolve=NO
ARG pasv_addr=deluge.majicflight.com
ARG rsa_cert=/etc/ssl-certs/vsftpd.pem
ARG rsa_key=/etc/ssl-certs/vsftpd.pem

# Env vals
ENV VUSER=${VUSER}
ENV VPASS=${VPASS}
ENV VGRP=${VGRP}
ENV port_ftp_data=${port_ftp_data}
ENV port_ftp_ctrl=${port_ftp_ctrl}
ENV port_ftps_imp=${port_ftps_imp}
ENV port_pasv_min=${port_pasv_min}
ENV port_pasv_max=${port_pasv_max}
ENV pasv_addr_resolve=${pasv_addr_resolve}
ENV pasv_addr=${pasv_addr}
ENV rsa_cert=${rsa_cert}
ENV rsa_key=${rsa_key}

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
