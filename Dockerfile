FROM alpine:3.5
MAINTAINER Jon Schulberger <jschoulzy@gmail.com>

ARG DUSER=deluge

EXPOSE 20 21 990 10100 10100

RUN adduser ${DUSER} -D

RUN apk add --no-cache \
    vsftpd

RUN mkdir -p /var/run/vsftpd/empty
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN echo ${DUSER} >> /etc/vsftpd/vsftpd.userlist
COPY vsftpd_init.sh /vsftpd_init.sh

# Enforce permissions on init script and home directory
RUN chmod a+x /vsftpd_init.sh && \
    chmod a-w /home/${DUSER}

CMD ["/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf"]
