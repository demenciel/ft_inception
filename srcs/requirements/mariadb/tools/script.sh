#!/bin/bash

log_success() {
  echo -e "\033[32m$1\033[0m"  # Vert
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
log_info "Creating database..."
mysql -u root -p  -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
log_success "Database created!"
sleep 1
log_info "Creating user..."
mysql -u root -p  -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'wordpress.srcs_inception' IDENTIFIED BY '${DB_PASSWORD}';"
mysql -u root -p  -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'wordpress.srcs_inception';"
log_success "Users created!"
sleep 1
log_info "Flushing privileges..."
mysql -u root -p  -e "FLUSH PRIVILEGES"
log_success "Privileges flushed!"
sleep 1
log_info "Stopping mariadb services..."
mysqladmin -u root -p  shutdown

exec mysqld_safe
