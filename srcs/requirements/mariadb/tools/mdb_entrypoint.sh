#!/bin/sh

set -e

#CONFIG FILE
cat << EOF > /etc/my.cnf
[mysqld]
user=mysql
datadir=${MYSQL_DATADIR}
port=${MARIADB_PORT}
bind-address=0.0.0.0
socket=/run/mysqld/mysqld.sock
EOF

if [ -d "${MYSQL_DATADIR}/mysql" ]; then
	echo "Database already initialized, starting MariaDB..."
else

mysql_install_db --user=mysql --datadir=${MYSQL_DATADIR}

mysqld --datadir=${MYSQL_DATADIR} &

while ! mysqladmin ping --silent; do
    echo "Esperando a que MariaDB esté listo..."
    sleep 1
done

#CREATE DATABASE
cat << EOF > /var/lib/mysql/init-db.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS "${MYSQL_ROOT}"@"localhost" IDENTIFIED BY "${MYSQL_ROOT_PASSWORD}";
ALTER USER 'root'@'localhost' IDENTIFIED BY "${MYSQL_ROOT_PASSWORD}";
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO "${MYSQL_ROOT}"@"localhost" WITH GRANT OPTION;

CREATE USER IF NOT EXISTS "${MYSQL_USER}"@"localhost" IDENTIFIED BY "${MYSQL_USER_PASSWORD}";
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO "${MYSQL_USER}"@"localhost";

FLUSH PRIVILEGES;
EOF

mysql -u root p${MYSQL_ROOT_PASSWORD} < ${MYSQL_DATADIR}/init-db.sql
mysqladmin shutdown -u root -p"$MYSQL_ROOT_PASSWORD"

fi

echo "Ejecutando Mariadb!"

exec su-exec mysql $@
