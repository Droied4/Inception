#!/bin/sh

set -e


until nc -z -v -w30 mariadb 3306; do
  echo "Esperando a que MariaDB esté disponible en la red..."
  sleep 30
done

echo "listo parce"

#DOWNLOADING WORDPRESS!
#if [ ! -f /var/www/html/index.php ]; then
#	cd /var/www/html && \
#	curl -O https://wordpress.org/wordpress-${WP_VERSION}.tar.gz && \
#	tar -xzvf wordpress-${WP_VERSION}.tar.gz && \
#	rm wordpress-${WP_VERSION}.tar.gz
#	mv /wp-config.php /var/www/html/wordpress/wp-config.php
#	#Change permission
#	chmod -R 755 /var/www/html
#
#	#LISTEN CONNECTIONS
#	sed -i 's/^listen = 127\.0\.0\.1:9000/listen = 0.0.0.0:9000/' /etc/php82/php-fpm.d/www.conf
#
#fi

#el mv no se tiene que hacer siempre
mv /wordpress/* /var/www/html/

exec "$@" -F
