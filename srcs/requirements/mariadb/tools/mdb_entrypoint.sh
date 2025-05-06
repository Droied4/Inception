#!/bin/sh

set -e

echo "Copying configuration file"
#CONFIG FILE
cat << EOF > /etc/my.cnf
[mysqld]
user=mysql
datadir=${MYSQL_DATADIR}
port=${MARIADB_PORT}
bind-address=0.0.0.0
socket=/run/mysqld/mysqld.sock
EOF

echo "Creating Database"
if [ -d "${MYSQL_DATADIR}/mysql" ]; then
	echo "Database already initialized, starting MariaDB..."
else

mysql_install_db --user=mysql --datadir=${MYSQL_DATADIR} > /dev/null 2>&1

mysqld --datadir=${MYSQL_DATADIR} &

while ! mysqladmin ping --silent; do
    echo "Waiting for Mariadb..."
    sleep 1
done

#CREATE DATABASE

db_password_file=/run/secrets/db_password
db_root_password_file=/run/secrets/db_root_password


if [ -f $db_password_file ] && [ -f $db_root_password_file ]; then

db_password=$(cat $db_password_file)
db_root_password=$(cat $db_root_password_file)

cat << EOF > ${MYSQL_DATADIR}/init-db.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS "${MYSQL_ROOT}"@"%" IDENTIFIED BY "$db_root_password";
ALTER USER 'root'@'localhost' IDENTIFIED BY "$db_root_password";
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO "${MYSQL_ROOT}"@"%" WITH GRANT OPTION;

CREATE USER IF NOT EXISTS "${MYSQL_USER}"@"%" IDENTIFIED BY "$db_password";
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO "${MYSQL_USER}"@"%";

FLUSH PRIVILEGES;
EOF

else

echo "$db_password_file or $db_root_password_file not found..."
exit 1

fi

echo "Database Created!"

mysql -u root -p"$db_root_password" < ${MYSQL_DATADIR}/init-db.sql > /dev/null 2>&1
mysqladmin shutdown -u root -p"$db_root_password"

fi

exec su-exec mysql $@
