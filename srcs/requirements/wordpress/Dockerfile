# Set the base image
FROM alpine:3.20.2

# RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/main" > /etc/apk/repositories && \
#     echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories


# RUN apk update && apk add --no-cache php php-fpm ...

# # Install necessary packages including curl
# RUN apk add --no-cache php php-fpm php-mysqli php-curl \
#     php-zlib php-xml php-session php-mbstring php-json \
#     php-opcache php-pdo php-pdo_mysql php-phar php-gd \
#     php-iconv php-simplexml curl
RUN apk add --no-cache bash curl less vim nginx ca-certificates git tzdata zip \
    libmcrypt-dev zlib-dev gmp-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    php83-fpm php83-json php83-zlib php83-xml php83-xmlwriter php83-simplexml php83-pdo php83-phar php83-openssl \
    php83-pdo_mysql php83-mysqli php83-session \
    php83-gd php83-iconv php83-gmp php83-zip \
    php83-curl php83-opcache php83-ctype php83-apcu \
    php83-intl php83-bcmath php83-dom php83-mbstring php83-xmlreader mysql-client && apk add -u musl && \
    rm -rf /var/cache/apk/*


# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP (adjusted paths)
# RUN sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|' /etc/php83/php.ini && \
#     sed -i 's|user = lpraca-l|user = www-data|' /etc/php7/php-fpm.d/www.conf && \
#     sed -i 's|group = lpraca-l|group = www-data|' /etc/php7/php-fpm.d/www.conf
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php83/php.ini && \
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php83/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm83 /sbin/php-fpm

RUN getent group www-data || addgroup -S www-data && \
    id -u www-data || adduser -S www-data -G www-data

# Set up WordPress
WORKDIR /var/www/html
RUN mkdir -p /var/www/html
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

# Copy the configuration script
COPY ./tools/wp.sh /wp.sh

# Make sure the script is executable
RUN chmod +x /wp.sh

# Start WordPress configuration
CMD ["/wp.sh"]
