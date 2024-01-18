FROM alpine:3.18

RUN apk update && apk upgrade
RUN apk add nginx && apk add openssl && apk add openssh
RUN mkdir -p /etc/nginx/ssl
# La commande req crée et traite principalement des demandes de certificats au format PKCS#10. Elle peut en outre créer des certificats auto-signés.
# -x509 : Cette option crée un certificat auto-signé.
# -nodes : Cette option indique à OpenSSL de ne pas crypter la clé privée.
# -out : Cette option spécifie le nom du fichier de sortie pour le certificat auto-signé.
# -keyout : Cette option spécifie le nom du fichier de sortie pour la clé privée.
# -subj : Cette option permet de spécifier les informations du certificat.
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Quebec/O=42/OU=42/CN=login.42.fr/UID=login"
RUN mkdir -p /var/run/nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html
# change owner of the folder
RUN chmod 755 /var/www/html
# -R : recursive
# chown : change owner
# www-data : user
RUN if ! id -u www-data > /dev/null 2>&1; then adduser -u 82 -D -S -G www-data www-data; fi
RUN if ! getent group www-data > /dev/null 2>&1; then addgroup -g 82 -S www-data; fi

RUN chown -R www-data:www-data /var/www/html
COPY conf/fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf

# Run a script to start Nginx and test if the configuration is correct
COPY tools/start-nginx.sh /start-nginx.sh
RUN chmod +x /start-nginx.sh

CMD ["/start-nginx.sh"]
