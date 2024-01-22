#!/bin/sh

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Start the MariaDB service
service mysql start

# Wait for MariaDB to start and be ready to accept connections
echo "${GREEN}Waiting for MariaDB to start up${NC}"
counter=0
while ! mysqladmin ping -h localhost --silent; do
    counter=$((counter+1))
    if [ "$counter" -ge 60 ]; then
        echo "Failed to start MariaDB within 60 seconds"
        exit 1
    fi
    echo "Waiting for MariaDB to start..."
    sleep 1
done

# Initial database setup
echo "${GREEN}Initial db setup${NC}"
echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" > db1.sql
echo "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> db1.sql
echo "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';" >> db1.sql
echo "ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_ROOTPASSWORD}';" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

# Execute the SQL statements
mysql < db1.sql

# Give some time before killing the MySQL process
sleep 5

# Kill the MySQL process
kill $(cat /var/run/mysqld/mysqld.pid)

# Start MariaDB
mysqld
