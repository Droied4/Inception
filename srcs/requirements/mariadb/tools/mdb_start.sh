#!/bin/sh

# Lanzar el servidor como usuario mysql
exec su-exec mysql mysqld --port=$MARIADB_PORT --datadir=/var/lib/mysql --user=mysql
