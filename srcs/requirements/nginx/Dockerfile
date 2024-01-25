FROM alpine:3.17

RUN apk update && apk add nginx curl openssl

ADD conf/default.conf /etc/nginx/http.d/default.conf
ADD conf/ssl.conf /etc/nginx/ssl/ssl.conf

 RUN openssl req -x509 -nodes -days 365 \
 	-subj "/C=CA/ST=QC/O=42Quebec/CN=acouture.42.fr" \
 	-addext "subjectAltName=DNS:acouture.42.fr" \
 	-newkey rsa:2048 \
 	-keyout /etc/ssl/private/nginx-selfsigned.key \
 	-out /etc/ssl/certs/nginx-selfsigned.crt;


CMD ["nginx", "-g", "daemon off;"]
