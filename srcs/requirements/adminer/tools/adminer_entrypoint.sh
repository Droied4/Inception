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

download_adminer()
{
	volume_path=$1
	mkdir -p $volume_path
	if [ ! -f $volume_path/adminer.php ]; then
	echo "Installing Adminer"
	cd $volume_path && \
	curl -L -o adminer.php https://github.com/vrana/adminer/releases/download/v${ADMINER_VERSION}/adminer-${ADMINER_VERSION}-mysql-en.php
	fi
	echo "Adminer Instaled!"
}

conf_php()
{
	php_version=php$1
	conf_file=/etc/$php_version/php-fpm.d/www.conf
	sed -i 's/^listen = 127\.0\.0\.1:9000/listen = 0.0.0.0:8080/' $conf_file
	sed -i 's/^;clear_env = no/clear_env = no/' $conf_file
	echo "php conf complete!"
	if [ -f /adminer.php ]; then
		mv /adminer.php /var/www/html/
	fi
}

init_adminer()
{
	connection_loop "mariadb" "3306"
	add_group "adminer" "adminer" "/var/www/html"
	download_adminer "/var/www/html"
	conf_php "${PHP_VERSION}"
	exec php-fpm${PHP_VERSION} -F
}

if [ "$1" = "php" ]; then
	init_adminer
else
	exec "$@"
fi
