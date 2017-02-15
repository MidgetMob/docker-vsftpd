FROM ubuntu:latest
MAINTAINER Jon Schulberger <jschoulzy@gmail.com>

EXPOSE 20 21 990 10100 10100

RUN adduser deluge --disabled-login

RUN apt-get -qq update && \
    apt-get install -y vsftpd chkconfig && \
    rm -rf /var/lib/apt/lists/*
    
RUN chkconfig -add vsftpd
    
COPY vsftpd.conf /etc/vsftpd.conf
COPY vsftpd.userlist /etc/vsftpd.userlist

CMD ["service vsftpd start && tail -f /dev/null"]
