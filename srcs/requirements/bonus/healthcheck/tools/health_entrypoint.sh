#!/bin/sh 

set -e

required_env_vars="NGINX_PORT MARIADB_PORT WORDPRESS_PORT REDIS_PORT ADMINER_PORT VSFTPD_PORT"

check_env()
{
	missing=0
	for env in "${required_env_vars}"; do 
	eval value=\$env
	if [ -z "$value" ]; then
	echo "[ERROR] $env is missing aborting proccess"
	exit 1
	fi
	done
	echo "All env variables are set!"
}

safe_sed()
{
	name=$1
	file=$2
	lockdir="/tmp/html.lock"

	while ! mkdir "$lockdir" 2>/dev/null; do
		sleep 0.1
	done

	sed -i "s|<h2> $name : Waiting... </h2>|<h2> $name : OK! </h2>|" $file
	rmdir "$lockdir"
}

check_service()
{
	name=$1
	host=$2
	port=$3
	file=$4

	until nc -z "$host" "$port"; do
		echo "Waiting for $name"
		sed -i "s|<h2> $name : OK! </h2>|<h2> $name : Waiting... </h2>|" $file
		sleep 2
	done
	echo "$name Operative!"
	safe_sed "$name" "$file"
}

generate_html()
{
	file=$1
cat << EOF > $file
<html>
<body>
<title> Health Check </title>
<h1> Status of the services </H1>
<h2> Nginx : Waiting... </h2>
<h2> MariaDb : Waiting... </h2>
<h2> Wordpress : Waiting... </h2>
<h2> Redis : Waiting... </h2>
<h2> Ftp Server : Waiting... </h2>
<h2> Adminer : Waiting... </h2>
</body>
</html>
EOF

}

init_healthcheck()
{
	file=/var/www/html/health/index.html
	check_env
	mkdir -p /var/www/html/health
	generate_html "$file"
	while true; do
	check_service "Nginx" "nginx" "${NGINX_PORT}" "$file" &
	check_service "MariaDb" "mariadb" "${MARIADB_PORT}" "$file" &
	check_service "Wordpress" "wordpress" "${WORDPRESS_PORT}" "$file" &
	check_service "Redis" "redis" "${REDIS_PORT}" "$file" &
	check_service "Adminer" "adminer" "${ADMINER_PORT}" "$file" &
	check_service "Ftp Server" "vsftPd" "${VSFTPD_PORT}" "$file" &
	wait
	sleep 300
	done
}

init_healthcheck
