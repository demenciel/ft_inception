#!/bin/sh

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

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
echo "CREATE DATABASE IF NOT EXISTS \`your_database\`;"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`your_database\`;"
echo "CREATE USER IF NOT EXISTS \`your_user\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`your_user\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
echo "GRANT ALL PRIVILEGES ON \`your_database\`.* TO \`your_user\`@'%';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`your_database\`.* TO \`your_user\`@'%';"
echo "FLUSH PRIVILEGES;"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

echo "${GREEN}Initial db setup done${NC}"
