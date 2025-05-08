#!/bin/sh

set -e

add_group()
{
	function=add_group
	group=$1
	group_id=$2
	user=$3
	user_id=$4
	dir=$5

	if [ ! getent group "$group" ] && [ ! getent group "$group_id" ] > /dev/null 2>&1; then
		addgroup -g $group_id -S $group; \
	fi 
	if [ ! getent passwd "$user"] && [ ! getent passwd "$user_id" ] > /dev/null 2>&1; then
		adduser -S -D -H -u $user_id -s /sbin/nologin -g $group $user;
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
		-subj "/C=ES/ST=Catalonia/L=Barcelona/O=42Barcelona/OU=42 School/CN=deordone.42.fr" \
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
	add_group "nginx" "33" "nginx" "33" "var/www/html"
	generate_ssl_cert
	start_templates
}

if [ "$1" = "nginx" ]; then
	init_nginx
fi

exec "$@"
