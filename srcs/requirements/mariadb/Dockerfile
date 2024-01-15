FROM alpine:3.18

RUN apk update && apk upgrade
# Installing the package will install mariadb-cient and mariadb-server
RUN apk add mariadb mariadb-client

COPY conf/my.conf /etc/my.conf

# Initialize the database
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql

# Copy the script that will start the server
COPY tools/init_db.sh /init_db.sh

RUN chmod +x /init_db.sh

CMD ["/init_db.sh"]

