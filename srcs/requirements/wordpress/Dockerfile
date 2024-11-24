#Set base OS
FROM debian:bullseye

#Install dependencies 
RUN apt update -y
RUN apt install wget curl php php-common php-mysql php-gmp \
    php-curl php-intl php-mbstring php-xmlrpc php7.4-fpm\
    php-gd php-xml php-cli php-zip software-properties-common netcat mariadb-client -y

#Install WP-CLI (wordpress command line)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

#Make directory
RUN mkdir -p /var/www/html
RUN mkdir /run/php/

#Install Wordpress
RUN wget https://wordpress.org/latest.tar.gz && tar -xvzf latest.tar.gz && \
    mv wordpress /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/ && \
    chmod 755 /run/php/ && \
    rm -f latest.tar.gz

RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

#Set workind directory
WORKDIR /var/www/html

#Copy files 
COPY ./tools/wp.sh /wp.sh

# Make sure the script is executable
RUN chmod +x /wp.sh

ENTRYPOINT [ "/wp.sh" ]

CMD ["/usr/sbin/php-fpm7.4", "-F"]
