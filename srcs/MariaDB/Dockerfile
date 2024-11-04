#set "OS"
FROM alpine:3.20 

#install dependencies
RUN apk add --no-cache mariadb mariadb-client;

#copy script to the dokerimage
COPY maria.sh, /maria.sh

#make the script executable
RUN chmod +x /maria.sh

#run the script
CMD ./maria.sh