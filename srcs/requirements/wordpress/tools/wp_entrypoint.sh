#!/bin/sh

set -e

connection_loop()
{
	service=$1
	port=$2
	until nc -z -v -w30 $service $port; do
	  echo "Waiting for $service it is available on the network..."
	  sleep 5
	done
	echo "Maria DB Ready"
}

download_wp()
{
	volume_path=$1
	if [ ! -f $volume_path/index.php ]; then
	echo "Installing Wordpress"
	cd $volume_path && \
	curl -O https://wordpress.org/wordpress-${WP_VERSION}.tar.gz > /dev/null 2>&1 && \
	tar -xzf wordpress-${WP_VERSION}.tar.gz --strip-components=1 && \
	rm wordpress-${WP_VERSION}.tar.gz
	fi
	echo "Wordpress Instaled!"
}

add_group()
{
	group=$1
	user=$2
	dir=$3

	if ! getent group "$group" > /dev/null 2>&1; then
	addgroup -S $group
	fi 
	if ! getent passwd "$user" > /dev/null 2>&1; then
	adduser -S -G $group $user
	fi
	chown -R $user:$group $dir
}

conf_php()
{
	php_version=$1
	conf_file=/etc/$1/php-fpm.d/www.conf
	sed -i 's/^listen = 127\.0\.0\.1:9000/listen = 0.0.0.0:9000/' $conf_file
	sed -i 's/^user = nobody/user = www-data/' $conf_file
	sed -i 's/^group = nobody/group = www-data/' $conf_file
	sed -i 's/^;clear_env = no/clear_env = no/' $conf_file
	echo "php conf complete!"
	if [ -f /wp-config.php ]; then
		mv /wp-config.php $volume_path/
	fi
}

init_wp()
{
	connection_loop "mariadb" "3306"
	add_group	"www-data" "www-data" "/var/www/html"
	download_wp 	"/var/www/html"
	conf_php 	"${PHP_VERSION}"
}

init_wp

exec "$@" -F
