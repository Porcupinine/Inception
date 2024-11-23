#!/bin/bash
set -x  # show all commands
set -e  # Exit immediately if a command exits with a non-zero status

# Function to gracefully shut down MariaDB
quit_maria() {
	mysqladmin -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" shutdown
	echo "MariaDB has shut down."
}

# Trap to catch termination signals and run quit_maria
trap "quit_maria" SIGTERM SIGINT EXIT

# Debugging step
echo "DIR_DATA is set to: $DIR_DATA"

# Check if MariaDB has been initialized by looking for the ibdata1 file
if [ ! -f "$DIR_DATA/db_setup.lock" ]; then
	echo "Initializing my database..."

	# Start MariaDB temporarily to create database and users
	service mariadb start

	# Create the database and user using environment variables
	mariadb -u root <<EOF
	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
	CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
	FLUSH PRIVILEGES;
EOF

	service mariadb stop

	echo "Database '$MYSQL_DATABASE' and user '$MYSQL_USER' have been created and configured."
	touch $DIR_DATA/db_setup.lock
else
	echo "MariaDB is already initialized."
fi

# Start MariaDB in normal mode
echo "Starting MariaDB..."
exec gosu mysql "$@"
