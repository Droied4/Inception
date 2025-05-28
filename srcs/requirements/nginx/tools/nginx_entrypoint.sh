#!/bin/sh

set -e

add_group()
{
	group=$1
	user=$2
	dir=$3

	if  ! getent group "$group" > /dev/null 2>&1; then
		addgroup -S $group; 
	fi 
	if  ! getent passwd "$user" > /dev/null 2>&1; then
		adduser -S -D -H -s /sbin/nologin -g $group $user;
	fi
	chown -R $user:$group $dir
	
}

generate_ssl_cert()
{
	echo "Generating SSL certification"
	mkdir -p ${SSL_PATH} > /dev/null 
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout ${SSL_PATH}/${DOMAIN_NAME}.key \
		-out	${SSL_PATH}/${DOMAIN_NAME}.crt \
		-subj "/C=ES/ST=Catalonia/L=Barcelona/O=42Barcelona/OU=42 School/CN=${DOMAIN_NAME}" \
		> /dev/null 2>&1
	echo "SSL Certification Generated!"
}

start_templates()
{
	echo "Applying templates configuration"
	envsubst '${NGINX_PORT} ${DOMAIN_NAME} ${SSL_PATH} ${NGINX_BDIR}' < /nginx.cnf.template > /etc/nginx/nginx.conf
	echo "Configuration Complete! Starting Nginx..."
}

init_nginx()
{
	add_group "nginx" "nginx" "var/www/html"
	generate_ssl_cert
	start_templates
	exec "$@"
}

if [ "$1" = "nginx" ]; then
	init_nginx "$@"
else
	exec "$@"
fi
