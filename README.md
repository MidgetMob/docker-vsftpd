# Build
docker build github.com/MidgetMob/docker-vsftpd.git --build-arg VUSER=<user> --build-arg VPASS=<pass>
docker tag <container-id> <docker name>/<repo> | I.E. jschulberger/vsftpd
docker push <docker name>/<repo>
