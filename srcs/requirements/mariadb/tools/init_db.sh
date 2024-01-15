#!/bin/sh
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Validate required environment variables
if [ -z "$SQL_ROOT_PASSWORD" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ] || [ -z "$SQL_DATABASE" ]; then
    echo "${RED}Error: Required environment variables are not set.${NC}"
    exit 1
fi

# Start MariaDB service
echo "${GREEN}Starting MariaDB service${NC}"
mysqld_safe &
pid="$!"

# Wait for MariaDB to start
sleep 20

# Initial database setup
echo "${GREEN}Initial db setup${NC}"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -u root -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Shutdown MariaDB service
mysqladmin -u root -p"$SQL_ROOT_PASSWORD" shutdown

# Wait for the operations to complete
echo "${GREEN}Wait for the operations to complete${NC}"
wait "$pid"

# Run MariaDB in the foreground to keep the container running
echo "${GREEN}Running MariaDB in the foreground${NC}"
exec mysqld_safe

