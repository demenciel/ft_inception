#!/bin/sh
# WordPress script
# Wait for the database to be ready
sleep 10

# Check if wp-config.php exists
if [ ! -f /var/www/html/wp-config.php ]; then
    # Configure WordPress settings
    wp config create --dbname="${WORDPRESS_DB_NAME}" \
                     --dbuser="${WORDPRESS_DB_USER}" \
                     --dbpass="${WORDPRESS_DB_PASSWORD}" \
                     --dbhost="mariadb:3306" \
                     --allow-root \
                     --path='/var/www/html/'
                     
    # Install WordPress with the initial configuration
    wp core install --url="${WP_SITE_URL}" \
                    --title="${WP_SITE_TITLE}" \
                    --admin_user="${WP_ADMIN_USER}" \
                    --admin_password="${WP_ADMIN_PASSWORD}" \
                    --admin_email="${WP_ADMIN_EMAIL}" \
                    --skip-email \
                    --allow-root \
                    --path='/var/www/html/'

    # Create an additional user if needed
    wp user create \
        "${WP_ADDITIONAL_USER}" \
        "${WP_ADDITIONAL_USER_EMAIL}" \
        --role=editor \
        --user_pass="${WP_ADDITIONAL_USER_PASSWORD}" \
        --allow-root \
        --path='/var/www/html/'
fi

# Change ownership of the WordPress files
addgroup -S www-data && adduser -S -G www-data www-data
chown -R www-data:www-data /var/www/html/

# Start PHP-FPM in the foreground
exec php-fpm7 -F
