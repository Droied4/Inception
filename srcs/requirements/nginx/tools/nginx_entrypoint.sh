#!/bin/sh

set -e

#GENERATE SSL CERTIFICATION
SSL_PATH=/etc/nginx/ssl
mkdir -p ${SSL_PATH} >/dev/null 
openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout ${SSL_PATH}/nginx.key \
		-out	${SSL_PATH}/nginx.crt \
		-subj "/C=ES/ST=Catalonia/L=Barcelona/O=42Barcelona/OU=42 School/CN=deordone.42.fr"

#TEMPLATE NGINX CONF
envsubst < /nginx.cnf.template > /etc/nginx/nginx.conf

$@ -g "daemon off;"
