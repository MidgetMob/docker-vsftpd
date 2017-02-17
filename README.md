This package is designed to be used alongside at least one other container as a remote access point for service-related files. Some useful pairings might be Plex or a seedbox. It is designed around supporting only one user.

Supports:
* FTP
* FTPS 

# Build
1. docker build https://github.com/MidgetMob/docker-vsftpd.git [--build-arg key=value]  
3. docker tag \<container id> \<docker name>/\<repo>  
3. docker push \<docker name>/\<repo> (*optional*)  

*Any ports that need to be exposed should be added during the initial container build.*

# Configuration
By default the FTP server uses active mode and is plain FTP. This mode requires the following:
* Environment Variables
  * VUSER
  * VPASS
  * VGRP
* Volumes
  * Any data volume to be accessed via FTP(s) should be mapped to a folder in /home/\<USER>.
* Ports
  * Any necessary ports should be mapped from the host to this container.
  
### Enabling SSL
* Environment Variables
  * ssl_enable
  * rsa_cert
  * rsa_key
* Volumes
  * Certs/keys should be generated on the host and then mapped via volumes (see below for examples).

### Passive mode
* Environment Variables
  * pasv_addr
  * pasv_addr_resolve
  * port_pasv_min
  * port_pasv_max

### Custom configuration file
* Environment Variables
  * custom_conf
  * custom_conf_loc

# Configuration Notes
* Enabling SSL and/or passive mode
  * **All** requirements mentioned above are required to be set at the time of enabling.
* Credentials
  * Password can be specified during container build but it is recommended to set the password via the environment variable.

# Other Notes
* To avoid weird permission errors, either the user (VUSER) or group (VGRP) should match that of other containers accessing the same data volumes.
* You may override any of the environment variables either during the initial container build process or when declaring a new container (examples below).
* Providing a custom configuration file requires port mapping/exposure for the container.
* I recommend setting a memory limit on the deployed container (200 MiB).

# Volume Configuration Examples
Host Path | Container Path
--------- | --------------
/cert/location/on/host.crt | /cert/location/on/client.crt:ro
/key/location/on/host.key | /cert/location/on/client.key:ro
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
pasv_enable | NO | enable passive mode
port_pasv_min | 0 | passive ftp minimum port  
port_pasv_max | 0 | passive ftp maximum port
pasv_addr_resolve | YES | whether or not the pasv_addr is a hostname
pasv_addr | ftp.mysite.com | hostname or ip that points to this server  
ssl_enable | NO | enable SSL/TLS for transfers
rsa_cert | /etc/ssl-certs/vsftpd.pem | location of the ssl certificate in the container  
rsa_key | /etc/ssl-certs/vsftpd.pem | location of the ssl key in the container
custom_conf | false | should vsftpd use a custom configuration file
custom_conf_loc | -- | path to the custom configuration file in the container
