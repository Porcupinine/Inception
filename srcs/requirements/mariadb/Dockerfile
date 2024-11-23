# Set the base image
FROM debian:bullseye 

# Install dependencies
RUN apt update && apt install -y mariadb-server mariadb-client
RUN apt update && apt install -y gosu

# Create marias directorys, set  groups, ownerships and permissions 
RUN mkdir -p /var/log/mysql /var/lib/mysql
RUN getent group mysql || groupadd -r mysql && \
    getent passwd mysql || useradd -r -g mysql mysql
RUN chown -R mysql:mysql /var/lib/mysql /var/log/mysql
RUN chmod 755 /var/lib/mysql /var/log/mysql
RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld
RUN chmod 755 /run/mysqld

# Copy the setup script to the Docker image
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/mariadb.cnf
COPY ./tools/mariadb.sh /mariadb.sh

# Make the script executable
RUN chmod +x /mariadb.sh

#set working directory 
WORKDIR /var/lib/mysql

# Use ENTRYPOINT for the setup script
ENTRYPOINT [ "/mariadb.sh" ]

CMD ["mysqld"]
