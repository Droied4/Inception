#!/bin/sh

mysql_install_db --user=mysql --datadir=/var/lib/mysql

#CONFIG FILE
	cat << EOF > /etc/my.cnf
	[mysqld]
	user=mysql
	datadir=/var/lib/mysql
	port=${MARIADB_PORT}
	bind-address=0.0.0.0
	socket=/run/mysqld/mysqld.sock
EOF

#CREATE DATABASE
	cat << EOF > /var/lib/mysql/init-db.sql
	CREATE DATABASE IF NOT EXIST ${MYSQL_DATABASE}
	CREATE USER '${MYSQL_USER}' IDENTIFIED BY '${USER_PASSWORD}';
	CREATE USER '${MYSQL_ADMIN}' IDENTIFIED BY '${ADMIN_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE} TO '${MYSQL_ADMIN}';
	FLUSH PRIVILEGES;
EOF

#mysql -u root -p ${MYSQL_DATABASE} < /var/lib/mysql/init-db.sql

exec su-exec mysql $@
