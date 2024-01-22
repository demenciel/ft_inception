FROM debian:buster


RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./tools/50-server.conf /etc/mysql/mariadb.conf.d/


COPY ./tools/script.sh /


CMD ["/script.sh"]