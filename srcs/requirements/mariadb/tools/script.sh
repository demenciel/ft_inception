#!/bin/bash

log_success() {
  echo -e "\033[32m$1\033[0m"  # Vert
}

log_wait() {
  echo -e "\033[33m$1\033[0m"  # Jaune
}

log_info() {
  echo -e "\033[34m$1\033[0m"  # Bleu
}

log_info "Starting mariadb service..."
service mysql start

sleep 1
log_info "Waiting for Mariadb..."
while true; do
    if mysqladmin ping -h localhost -u root -p  --silent; then
        break
    fi
    log_info "waiting..."
    sleep 1
done
log_success "Mariadb is up and running."


sleep 1
mysql -u root -p  -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
sleep 1
mysql -u root -p  -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'wordpress.srcs_inception' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -u root -p  -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'wordpress.srcs_inception';"
sleep 1
mysql -u root -p  -e "FLUSH PRIVILEGES"

sleep 1
log_info "Stopping mariadb services..."
mysqladmin -u root -p  shutdown

exec mysqld_safe
