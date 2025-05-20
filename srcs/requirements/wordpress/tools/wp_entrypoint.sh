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

download_redis()
{
	version=$1
	volume_path=$2
	
	if [ ! -d $volume_path/wp-content/plugins/redis-cache ]; then
	curl -L https://downloads.wordpress.org/plugin/redis-cache.$version.zip -o redis-cache.zip
	unzip redis-cache.zip
	rm redis-cache.zip
	mv /redis-cache $volume_path/wp-content/plugins/
	echo "Redis-cache plugin instaled!"
		else
	echo "Redis-cache plugin already instaled"
	fi
	if [ ! -f $volume_path/wp-content/object-cache.php ]; then
	    cp $volume_path/wp-content/plugins/redis-cache/includes/object-cache.php $volume_path/wp-content/object-cache.php
	    echo "Object cache activated"
	fi
}

add_group()
{
	group=$1
	user=$2
	dir=$3

	if ! getent group "$group" > /dev/null 2>&1; then
		addgroup -S $group;
	fi 
	if ! getent passwd "$user" > /dev/null 2>&1; then
		adduser -S -D -H -s /sbin/nologin -g $group $user;
	fi
	chown -R $user:$group $dir
}

conf_php()
{
	php_version=php$1
	conf_file=/etc/$php_version/php-fpm.d/www.conf
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
	download_redis	"2.5.0" "var/www/html"
	conf_php 	"${PHP_VERSION}"
	exec php-fpm${PHP_VERSION} -F
}

if [ "$1" = "php" ]; then
	init_wp
else
	exec "$@"
fi
