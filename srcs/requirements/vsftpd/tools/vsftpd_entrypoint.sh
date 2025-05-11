#!/bin/bash 

set -e

configure_user()
{
	user=$1
	group=$2
	password=$3
	
	adduser sammy --disabled-password
	#for alpine users
	# if ! getent group "$group" > /dev/null 2>&1; then
	# 	echo "Add group $group"
	# 	addgroup -S "$group";
	# fi
	# if ! getent passwd "$user" > /dev/null 2>&1; then
	# 	echo "Add user $user"
	# 	adduser -S -D -G "$group" "$user";
	# fi

 	echo "$user:$password" | /usr/sbin/chpasswd
 	echo "$user" >> /etc/vsftpd.userlist
}

configure_folder()
{
	user=$1
	if [ ! -d /home/$user/ftp ]; then
		mkdir -p /home/$user/ftp
	fi
	chown nobody:nogroup /home/$user/ftp
	chmod a-w /home/$user/ftp

	if [ ! -d /home/$user/ftp/files ]; then
		mkdir -p /home/$user/ftp/files
	fi
	chown $user:$user /home/$user/ftp/files
}

start_templates()
{
	template=$1
	dir=$2
	echo "Applying templates configuration"
	envsubst '${VSFTPD_PORT} ${VSFTPD_DATA_PORT} ${VSFTPD_USER}' < $template > $dir
	echo "Configuration Complete! Starting VsFTPd Server..."
}

init_vsftpd()
{
	mkdir -p /var/run/vsftpd/empty
	chmod 755 /var/run/vsftpd/empty
	configure_user "$VSFTPD_USER" "$VSFTPD_USER" "$VSFTPD_PASS"
	configure_folder "$VSFTPD_USER"
	start_templates "/vsftpd.cnf.template" "/etc/vsftpd.conf"
	/usr/sbin/vsftpd /etc/vsftpd.conf
}

init_vsftpd $@

if [ "$1" = "vsftpd" ]; then
	init_vsftpd $@
else
	exec "$@"
fi
