FROM alpine:3.17

# Install PHP and required extensions along with wget and mariadb-client
RUN apk --no-cache update && \
    apk --no-cache add php81 php81-fpm php81-mysqli php81-pdo php81-pdo_mysql php81-phar php81-mbstring mariadb-client wget

# Copy PHP-FPM config
COPY ./conf/www.conf /etc/php81/php-fpm.d/www.conf

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Prepare WordPress directory
WORKDIR /var/www/

# Download and extract WordPress, ensuring the files are placed directly in /var/www/
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -O wordpress.tar.gz && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz

# Set the working directory to /var/www/wordpress
WORKDIR /var/www/wordpress

# Ensure the wp-config.php is placed correctly
#COPY conf/wp-config.php /var/www/wp-config.php

# Copy and set permissions for the entry script
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

# Expose port for PHP-FPM
EXPOSE 9000

# Set the entrypoint to the script
ENTRYPOINT ["/script.sh"]

# Uncomment if you want to start PHP-FPM as the main process
# CMD ["php-fpm81", "--nodaemonize"]
