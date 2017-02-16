This package is designed to be used alongside at least one other container as a remote access point for service-related files. Some examples would be Plex or a seedbox.

Supports:
* FTP
* FTPS

# Configuration
* You may override any of the environment variables either during the container build process or when declaring a new container
* You may provide your own configuration however this means no environment variables will be used. User, password, and ports should still be specified during the initial container build.

# Other Notes
* You must have a cert/key pair for ssl encryption mounted somewhere in the container with ro privileges
* User or group should mirror data container user/group
* Data volumes should be mounted as a subfolder of /home/\<USER> with rw privileges
* Specified ports should be mapped from the host to this container

*Example for mounting volumes*

Host Path | Container Path
--------- | --------------
/cert/location/on/host.pem | /cert/location/on/client.pem:ro
plex-data-volume | /home/\<USER>/plex-data:rw

# Available Environment Variables
Variable Name | Default Value | Description
------------- | ------------- | -----------
VUSER | ftpuser | ftp user  
VPASS | ftpuser | ftp user password  
VGRP | ftpgroup | ftp group  
port_ftp_data | 20 | ftp data port 
port_ftp_ctrl | 21 | ftp ctrl port  
port_ftps_imp | 990 | implicit ftp port  
port_pasv_min | 10100 | passive ftp minimum port  
port_pasv_max | 10101 | passive ftp maximum port
pasv_addr_resolve | YES | whether or not the pasv_addr is a hostname
pasv_addr | ftp.mysite.com | hostname or ip that points to this server  
rsa_cert | /etc/ssl-certs/vsftpd.pem | location of the ssl certificate in the container  
rsa_key | /etc/ssl-certs/vsftpd.pem | location of the ssl key in the container

# Build
1. docker build https://github.com/MidgetMob/docker-vsftpd.git [--build-arg key=value]  
3. docker tag \<container id> \<docker name>/\<repo>  
3. docker push \<docker name>/\<repo> 
