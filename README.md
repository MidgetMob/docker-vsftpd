This package is designed to be used alongside at least one other container as a remote access point for service-related files. Some useful pairings might be Plex or a seedbox.

Supports:
* FTP
* FTPS

## Recommended Configuration
* Build Arguments (--build-arg key=value)
  * Ports
    * port_pasv_min
    * port_pasv_max
* Environment Variables (during or after initial container build)
  * Credentials
    * rsa_cert
    * rsa_key
    * VUSER
    * VPASS
    * VGRP
  * Ports
    * port_pasv_min
    * port_pasv_max
  * Address
    * pasv_addr
    * pasv_addr_resolve
* Volumes
  * rsa_cert
  * rsa_key
  * all data volumes

## How to Build
1. docker build https://github.com/MidgetMob/docker-vsftpd.git [--build-arg key=value]  
3. docker tag \<container id> \<docker name>/\<repo>  
3. docker push \<docker name>/\<repo> (*optional*)

## Configuration Notes
* Volumes (see examples below if unclear)
  * All data volumes mapped to some folder in /home/\<USER>
  * SSL certificate and key mapped to some location in the container
* Ports
  * Alternate FTP(s) ports **MUST** be specified during initial container build
  * Ports must be mapped from host when deploying this container
* IP address
  * pasv_addr **MUST** be set
  * Set pasv_addr_resolve accordingly (YES if pasv_addr is a hostname)
* Credentials
  * Username **MUST** be specified during container build
  * Password can be specified during container build but it is recommended to set the password via the environment variable

## Other Notes
* SSL key and certificate are required by default. A custom configuration can be specified to disable SSL
* To avoid weird permission errors, either the user (VUSER) or group (VGRP) should match that of other containers accessing the same data volumes
* You may override any of the environment variables either during the initial container build process or when declaring a new container (examples below)
* You may provide your own configuration however this means no vsftpd environment variables will be used. User and ports should still be specified during the initial container build however

## Volume Configuration Examples
Host Path | Container Path
--------- | --------------
/cert/location/on/host.crt | /cert/location/on/client.crt:ro
/key/location/on/host.key | /cert/location/on/client.key:ro
plex-data-volume | /home/\<USER>/plex-data:rw

## Available Environment Variables
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
