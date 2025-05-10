#!/bin/sh 

set -e

add_group()
{
	group=$1
	user=$2
	dir=$3

	if ! getent group "$group" > /dev/null 2>&1; then
		echo "Add group $group"
		addgroup -S $group;
	fi 
	if ! getent passwd "$user" > /dev/null 2>&1; then
		echo "Add user $user"
		adduser -S -D -H -s /sbin/nologin -G "$group" "$user";
	fi
	if [ -d "$dir" ]; then
		chown -R "$user:$group" "$dir"
	else
		echo "Creating and giving permission on $dir"
		mkdir -p "$dir"
		chown -R "$user:$group" "$dir"
	fi
}

start_templates()
{
	template=$1
	dir=$2
	echo "Applying templates configuration"
	envsubst '${VSFTPD_PORT} ${VSFTPD_DATA_PORT}' < $template > $dir
	echo "Configuration Complete! Starting VsFTPd Server..."
}

init_vsftpd()
{
	add_group "ftp" "ftp" "/var/www/html"
	start_templates "/vsftpd.cnf.template" "/etc/vsftpd/vsftpd.conf"
	exec "/usr/sbin/$@" /etc/vsftpd/vsftpd.conf
}

if [ "$1" = "vsftpd" ]; then
	init_vsftpd $@
else
	exec "$@"
fi
