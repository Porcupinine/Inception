# Set the base image
FROM alpine:3.20 

# Update and upgrade packages
# RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Install necessary packages
RUN apk add --no-cache php php-fpm php-mysqli php-curl \
    php-zlib php-xml php-session php-mbstring php-json \
    php-opcache php-pdo php-pdo_mysql php-phar php-gd \
    php-iconv php-simplexml


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


# Configure PHP
RUN sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|' /etc/php8/php.ini && \
    sed -i 's|user = nobody|user = www-data|' /etc/php8/php-fpm.d/www.conf && \
    sed -i 's|group = nobody|group = www-data|' /etc/php8/php-fpm.d/www.conf

# Set up WordPress
WORKDIR /var/www/html
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

# Configure Supervisor
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf\

#Copy scripts 
COPY ./tools/wp.sh /wp.sh

# Start services
CMD ["wp.sh"]