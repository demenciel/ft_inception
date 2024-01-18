#wordpress
FROM alpine:3.13

# Update and install necessary packages
RUN apk update && apk upgrade && \
    apk add --no-cache \
        wget \
        tar \
        mariadb-client \
        php7 \
        php7-fpm \
        php7-phar \
        php7-json \
        php7-mysqli 

# Download WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /tmp/

# Create the directory and extract WordPress
RUN mkdir -p /var/www/html && \
    tar -xzf /tmp/wordpress-6.0-fr_FR.tar.gz -C /tmp/ && \
    mv /tmp/wordpress/* /var/www/html/ && \
    rm -rf /tmp/wordpress-6.0-fr_FR.tar.gz /tmp/wordpress

# Set permissions
RUN chown -R root:root /var/www/html && \
    chmod -R 755 /var/www/html

# Modify the php-fpm configuration file to listen on port 9000 for Wordpress
COPY conf/www.conf /etc/php7/php-fpm.d/www.conf
RUN chown -R root:root /etc/php7/php-fpm.d/www.conf

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/auto_config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/auto_config.sh

VOLUME /var/www/html

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]
