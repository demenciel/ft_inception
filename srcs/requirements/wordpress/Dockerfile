FROM alpine:3.13

# Update and install necessary packages
RUN apk update && apk upgrade && \
    apk add --no-cache \
        wget \
        tar \
        mariadb-client \
        php7 \
        php7-fpm

# Download and extract WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /tmp/ && \
    tar -xzf /tmp/wordpress-6.0-fr_FR.tar.gz -C /var/www/html && \
    rm /tmp/wordpress-6.0-fr_FR.tar.gz

# Set permissions
RUN chown -R root:root /var/www/html/wordpress
