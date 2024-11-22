#!/bin/sh

# checking if mariadb is up and running before launching
while ! nc -zv $MARIA_HOST 3306; do
    echo "Waiting for MariaDB..." && sleep 5
done
echo "MariaDB is up!"

#checking if wp-config.php exist
if [ -f ./wp-config.php ]; then
    echo "WordPress already downloaded!"
else
    # downloads wordpress core files
    wp core download --allow-root
    # creates wp-config.php file with the database details
    wp core config --dbhost=mariadb:3306 --dbname="$WORDPRESS_MARIA_NAME" --dbuser="$WORDPRESS_MARIA_USER" --dbpass="$WORDPRESS_MARIA_PASSWORD" --allow-root
    wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_MAIL" --allow-root
    # create a new user with the below details
    wp user create "$WORDPRESS_MARIA_USER" "$WP_USER_MAIL" --user_pass="$WORDPRESS_MARIA_PASSWORD" --allow-root

    echo "WordPress configured!"
fi

# (CMD from dockerfile) start php-fpm service in the foreground to keep the container running
exec "$@"