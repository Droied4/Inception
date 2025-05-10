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

config_ftpserver()
{
	conf_file=/etc/vsftpd/vsftpd.conf
	if [ -f $conf_file ]; then
		sed -i 's/#write_enable=YES/write_enable=YES/1' $conf_file	
		sed -i 's/#local_enable=YES/local_enable=YES/1' $conf_file	
		echo "VsFTPd Configured!"
	else
		echo "$con_file Not found"
	fi
	
}

init_vsftpd()
{
	add_group "vsftpd" "vsftpd" "/var/www/html"
	config_ftpserver
	exec "/usr/sbin/$@"
}

if [ "$1" = "vsftpd" ]; then
	init_vsftpd $@
else
	exec "$@"
fi
