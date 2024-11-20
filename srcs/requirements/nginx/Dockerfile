# Set base image
FROM alpine:3.20

# Install Nginx, OpenSSL, and PHP dependencies
RUN apk add --no-cache nginx openssl \
    php-curl php-gd php-intl php-mbstring php-soap php-xml php-zip

# Create www-data user and group
RUN adduser -S www-data -G www-data

# Copy Nginx configuration
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Copy the startup script
COPY ./tools/nginx.sh /nginx.sh

# Make the script executable
RUN chmod +x /nginx.sh

# Set working directory
WORKDIR /var/www/html

# Use nginx.sh as the entrypoint
ENTRYPOINT ["/nginx.sh"]
