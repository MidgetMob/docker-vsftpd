# Build
docker build https://github.com/MidgetMob/docker-vsftpd.git [--build-arg key=value]
docker tag \<container id> \<docker name>/\<repo>  
docker push \<docker name>/\<repo>

# Other Requirements
You must have a cert/key pair for ssl encryption mounted somewhere in the container with ro privileges
User or group should mirror data container user/group
Data volumes should be mounted as a subfolder of /home/\<USER> with rw privileges
Specified ports should be mapped from the host to this container

# Available Environment Variables
Variable Name | Default Value | Description
------------- | ------------- | -----------
VUSER | deluge | ftp user  
VPASS | deluge | ftp user password  
VGRP | deluge | ftp group  
port_ftp_data | 20 ftp data port 
port_ftp_ctrl | 21 ftp ctrl port  
port_ftps_imp | 990 implicit ftp port  
port_pasv_min | 10100 passive ftp minimum port  
port_pasv_max | 10101 passive ftp maximum port  
pasv_addr|deluge.majicflight.com hostname that points to this ip  
rsa_cert|/etc/ssl-certs/vsftpd.pem location of the ssl certificate in the container  
rsa_key|/etc/ssl-certs/vsftpd.pem location of the ssl key in the container
