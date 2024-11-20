# Set the base image
FROM alpine:3.20 

# Update and upgrade packages
# RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Install dependencies
RUN apk add --no-cache mariadb mariadb-client

# Create marias directorys 
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Copy the setup script to the Docker image
COPY ./tools/mariadb.sh /mariadb.sh

# Make the script executable
RUN chmod +x /mariadb.sh

# Use ENTRYPOINT for the setup script
ENTRYPOINT [ "/mariadb.sh" ]

