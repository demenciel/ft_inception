# Description: MariaDB container
FROM alpine:3.18

RUN apk update && apk upgrade
# Installing the package will install mariadb-client and mariadb-server
RUN apk add mariadb mariadb-client

# Copy the MariaDB configuration file
COPY conf/my.conf /etc/my.conf
# Ensure the configuration file is readable
RUN chmod 644 /etc/my.conf

# Initialize the database
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql

# After initializing the database in init_db.sh
RUN chown -R mysql:mysql /var/lib/mysql
RUN chmod -R 755 /var/lib/mysql

# Copy the script that will start the server
COPY tools/init_db.sh /init_db.sh
RUN chmod +x /init_db.sh

CMD ["/init_db.sh"]
