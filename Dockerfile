FROM ubuntu:latest
MAINTAINER Jon Schulberger <jschoulzy@gmail.com>

EXPOSE 20 21 990 10100 10100

RUN adduser deluge --disabled-login
RUN chmod a-w /home/deluge

RUN apt-get -qq update && \
    apt-get install -y vsftpd && \
    rm -rf /var/lib/apt/lists/*
    
RUN systemctl enable vsftpd
    
COPY vsftpd.conf /etc/vsftpd.conf
COPY vsftpd.userlist /etc/vsftpd.userlist
COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
