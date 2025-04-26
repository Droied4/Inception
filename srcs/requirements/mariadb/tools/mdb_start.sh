#!/bin/sh

# Lanzar el servidor como usuario mysql
exec su-exec mysql mysqld --datadir=/var/lib/mysql --user=mysql
