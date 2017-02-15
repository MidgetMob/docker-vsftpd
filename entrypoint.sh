#!/bin/bash
service vsftpd start

tail -f /var/log/vsftpd.log
