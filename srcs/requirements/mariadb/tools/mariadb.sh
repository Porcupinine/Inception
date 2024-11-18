#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status

# Function to gracefully shut down MariaDB
quit_maria() {
    mysqladmin shutdown
    echo "MariaDB has shut down."
}

# Trap to catch termination signals and run quit_maria
trap "quit_maria" SIGTERM SIGINT EXIT

# Debugging step
echo "DIR_DATA is set to: $DIR_DATA"

# Create and set permissions for the data directory
mkdir -p "$DIR_DATA"
chown -R mysql:mysql "$DIR_DATA"

# Check if MariaDB has been initialized by looking for the ibdata1 file
if [ ! -f "$DIR_DATA/ibdata1" ]; then
    echo "Initializing MariaDB..."

    mariadb-install-db \
        --user="$USER" \
        --datadir="$DIR_DATA" \
        --auth-root-authentication-method=socket &
    wait $!
    
    # Start MariaDB temporarily to set up database and user
    mariadbd-safe --skip-networking &
    pid="$!"

    # Wait for MariaDB to be ready
    until mariadb -u root -e "status" &>/dev/null; do
      echo "Waiting for MariaDB to start..."
      sleep 1
    done

    # Create the database and user if they do not exist
    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Database '$MYSQL_DATABASE' and user '$MYSQL_USER' have been created and configured."

    # Stop the temporary MariaDB process
    kill "$pid"
    wait "$pid"
else
    echo "MariaDB is already initialized."
fi

# Start MariaDB in normal mode
echo "Starting MariaDB..."
exec mariadb
