FROM alpine:3.17

# Install php
RUN apk --no-cache update && \
    apk --no-cache add php81 php81-fpm php81-mysqli php81-pdo php81-pdo_mysql php81-phar php-mbstring mariadb-client && \
	apk --no-cache add wget

# Copy php-fpm config
ADD ./conf/www.conf /etc/php81/php-fpm.d/www.conf

# Install wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# RUN mkdir -p /var/www/html

# ADD tools/index.php /var/www/html/index.php

# COPY tools/script.sh /script.sh
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

WORKDIR /var/www

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P .
RUN tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz

WORKDIR /var/www/wordpress
# ADD conf/wp-config.php /var/www/wordpress/wp-config.php

EXPOSE 9000

ENTRYPOINT ["/script.sh"]

# CMD ["php-fpm81", "--nodaemonize"]
