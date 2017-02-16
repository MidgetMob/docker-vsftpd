FROM alpine:3.5
MAINTAINER Jon Schulberger <jschoulzy@gmail.com>

ARG VUSER=deluge
ARG VPASS=deluge

EXPOSE 20 21 990 10100 10100

RUN adduser ${VUSER} -D && \
    echo "${VUSER}:${VPASS}" | chpasswd

RUN apk add --no-cache \
    vsftpd && \
    mkdir -p /var/run/vsftpd/empty && \
    echo ${VUSER} >> /etc/vsftpd/vsftpd.userlist

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY vsftpd_init.sh /vsftpd_init.sh

# Enforce permissions on init script and home directory
RUN chmod a-w /home/${VUSER} && \
    chmod a+x /vsftpd_init.sh

CMD ["/vsftpd_init.sh"]
