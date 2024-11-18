# Set base image
FROM alpine:3.20

# Update and upgrade packages
# RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Install dependencies
RUN apk add --no-cache nginx
RUN apk add --no-cache php-curl php-gd php-intl php-mbstring php-soap php-xml php-zip

# Copy files
COPY ./conf/nginx.cnf /etc/nginx/nginx.cnf
COPY ./tools/nginx.sh /nginx.sh

# Make the script executable
RUN chmod +x /nginx.sh

#set working director
WORKDIR /var/www/html

# Test Nginx configuration
RUN nginx -t

# Run Nginx in the foreground with worker processes as 'nobody' user
CMD ["nginx", "-g", "daemon off;"]

ENTRYPOINT [ "nginx.sh" ]
