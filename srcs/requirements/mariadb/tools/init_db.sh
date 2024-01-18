#!/bin/sh
# init_db.sh
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Validate required environment variables
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ]; then
    echo "${RED}Error: Required environment variables are not set.${NC}"
    exit 1
fi

# Start MariaDB service
echo "${GREEN}Starting MariaDB service${NC}"
mysqld_safe &
pid="$!"

# Wait for MariaDB to start
echo "${GREEN}Waiting for MariaDB to start up${NC}"
counter=1
while [ $counter -le 30 ]; do
    if mysqladmin ping -h localhost -u root --password="${MYSQL_ROOT_PASSWORD}" &> /dev/null; then
        echo "${GREEN}MariaDB is up${NC}"
        break
    fi
    echo "Waiting for MariaDB to start..."
    sleep 1
    ((counter++))
done

if [ $counter -gt 30 ]; then
    echo "${RED}MariaDB did not start in time${NC}"
    exit 1
fi

# Initial database setup
echo "${GREEN}Initial db setup${NC}"
echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
echo "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
echo "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
echo "FLUSH PRIVILEGES;"
mysql -u root -e "FLUSH PRIVILEGES;"
echo "${GREEN}Initial db setup done${NC}"

# Shutdown MariaDB service
echo "${GREEN}Shutting down Mariadb services${NC}"
mysqladmin -u root -p "${MYSQL_ROOT_PASSWORD}" shutdown

# Wait for the operations to complete
echo "${GREEN}Wait for the operations to complete${NC}"
wait "$pid"

# Run MariaDB in the foreground to keep the container running
echo "${GREEN}Running MariaDB in the foreground${NC}"
exec mysqld_safe

