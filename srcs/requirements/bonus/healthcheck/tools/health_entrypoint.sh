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

check_service()
{
	name=$1
	host=$2
	port=$3

	until nc -z "$host" "$port"; do
		echo "Waiting for $name"
		sleep 2
	done
	echo "$name Operative!"
}

init_healthcheck()
{
	check_env
	check_service "nginx" "nginx" "${NGINX_PORT}" &
	check_service "mariadb" "mariadb" "${MARIADB_PORT}" &
	check_service "wordpress" "wordpress" "${WORDPRESS_PORT}" &
	check_service "redis" "redis" "${REDIS_PORT}" &
	check_service "adminer" "adminer" "${ADMINER_PORT}" &
	check_service "FTP server" "vsftPd" "${VSFTPD_PORT}" &
	wait
	echo "All services are operative :D!"
}

init_healthcheck
