FROM alpine:3.17

# Install PHP and required extensions along with wget and mariadb-client
RUN apk --no-cache update && \
    apk --no-cache add php81 php81-fpm php81-mysqli php81-pdo php81-pdo_mysql php81-phar php81-mbstring mariadb-client wget curl

# Copy PHP-FPM config
COPY ./conf/www.conf /etc/php81/php-fpm.d/www.conf

# Copy and set permissions for the entry script
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

# Expose port for PHP-FPM
EXPOSE 9000

# Set the entrypoint to the script
ENTRYPOINT ["/script.sh"]

# Uncomment if you want to start PHP-FPM as the main process
# CMD ["php-fpm81", "--nodaemonize"]
