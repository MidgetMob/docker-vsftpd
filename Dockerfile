FROM alpine:3.5
MAINTAINER Jon Schulberger <jschoulzy@gmail.com>

ARG DUSER=deluge

EXPOSE 20 21 990 10100 10100

RUN adduser ${DUSER} --disabled-login

RUN apk add --no-cache vsftpd
    
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY vsftpd.userlist /etc/vsftpd/vsftpd.userlist
COPY vsftpd_init.sh /vsftpd_init.sh

# Enforce permissions on init script and home directory
RUN chmod a+x /vsftpd_init.sh && \
    chmod a-w /home/${DUSER}

CMD ["/vsftpd_init.sh"]
