#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# Function to gracefully shut down MariaDB
quit_nginx() {
    nginx -s stop
	echo "Nginx has shut down."
}

# Trap to catch termination signals and run quit_maria
trap "quit_nginx" SIGTERM SIGINT EXIT

# Debugging step
echo "Starting Nginx setup..."


# echo "checking nginx config file"
# cat /etc/nginx/nginx.conf
# echo "that was it"

# Ensure www-data user and group exist
if ! id -u www-data &>/dev/null; then
    echo "Creating www-data user..."
    addgroup -S www-data && adduser -S www-data -G www-data
fi

# Ensure permissions are correct for the web directory
echo "Setting correct permissions for /var/www/html"
chown -R www-data:www-data /var/www/html

# Generate SSL certificates if they don't exist
if [ ! -f /etc/nginx/ssl/certs/inception.crt ]; then
    echo "hello"
    mkdir -p /etc/nginx/ssl/certs /etc/nginx/ssl/keys
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/certs/inception.key \
        -out /etc/nginx/ssl/certs/inception.crt \
        -subj "/C=US/ST=Test/L=Test/O=Test/OU=Test/CN=localhost"
    echo "SSL certificates generated."
fi

echo "SSL certificate or key:"
ls -l /etc/nginx/ssl/certs /etc/nginx/ssl/*

# Ensure the correct permissions for SSL files
echo "Setting permissions for SSL certificates"
chown -R www-data:www-data /etc/nginx/ssl

# Start Nginx in the foreground
echo "Starting Nginx..."
# exec "$@";
nginx -g "daemon off;"
echo "this shit is done and I'm done with this shit"