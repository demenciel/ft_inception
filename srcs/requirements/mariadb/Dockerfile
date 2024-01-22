# Use Alpine Linux as the base image
FROM alpine:3.18

# Install MariaDB server and client
RUN apk update && apk add mariadb mariadb-client

# Create a directory for MariaDB data
RUN mkdir -p /var/lib/mysql

# Copy the MariaDB configuration file
COPY conf/50-server.conf /etc/50-server.conf
# Ensure the configuration file is readable
RUN chmod 644 /etc/50-server.conf

# Initialize the database
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql

# Expose the default MySQL port
EXPOSE 3306

# Start MariaDB server on container startup
CMD ["mysqld", "--user=mysql"]
