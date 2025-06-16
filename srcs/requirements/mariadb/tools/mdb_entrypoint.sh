#!/bin/sh

set -e

error()
{
	file=mdb_entrypoint.sh
	message=$1
	echo "File: "$file" Fail: $message"
	exit
}

mysql_config_file()
{
	echo "Copying configuration file"
cat << EOF > /etc/my.cnf
	[mysqld]
	user=mysql
	datadir=${MYSQL_DATADIR}
	port=${MARIADB_PORT}
	bind-address=0.0.0.0
	socket=/run/mysqld/mysqld.sock
EOF
}

start_database()
{
	function=start_database

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

	create_database

	mysql -u root -p"$db_root_password" < ${MYSQL_DATADIR}/init-db.sql > /dev/null 2>&1
	mysqladmin shutdown -u root -p"$db_root_password"
fi
	
echo "Database Created!"

}

create_database()
{
	function=create_database
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

	CREATE USER IF NOT EXISTS "${MYSQL_USER}"@"localhost" IDENTIFIED BY "$db_password";
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO "${MYSQL_USER}"@"localhost";
	CREATE USER IF NOT EXISTS "${MYSQL_USER}"@"%" IDENTIFIED BY "$db_password";
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO "${MYSQL_USER}"@"%";

	FLUSH PRIVILEGES;
EOF

	else
		error "$db_password_file or $db_root_password_file not found..."
	fi
}



add_group()
{
	group=$1
	user=$2
	dir=$3

	if  ! getent group "$group" > /dev/null 2>&1; then
		addgroup -S $group; 
	fi 
	if  ! getent passwd "$user" > /dev/null 2>&1; then
		adduser -S -D -H -s /sbin/nologin -g $group $user;
	fi
	chown -R $user:$group $dir
	
}


init_mdb()
{
	add_group "mysql" "mysql" "/var/lib/mysql"
	mysql_config_file
	start_database 
	exec su-exec mysql $@
}

if [ "$1" = "mysqld" ]; then
	init_mdb "$@"
else
	exec "$@"
fi
