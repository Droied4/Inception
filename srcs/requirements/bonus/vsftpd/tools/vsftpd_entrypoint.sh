#!/bin/sh 

set -e

configure_user()
{
	user=$1
	dir=$2
	password=$3
	
	adduser --disabled-password "$user"

 	echo "$user:$password" | /usr/sbin/chpasswd
 	echo "$user" >> $dir/vsftpd.userlist
}

configure_folder()
{
	user=$1
	dir=$2
	if [ ! -d $dir ]; then
		mkdir -p /home/$user/ftp
	fi
	chown nobody:nogroup $dir
	chmod a-w $dir

	if [ ! -d $dir/files ]; then
		mkdir -p $dir/files
	fi
	chown $user:$user $dir/files
	usermod --home $dir/files "$user"
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
	configure_user "$VSFTPD_USER" "/etc/vsftpd" "$VSFTPD_PASS"
	configure_folder "$VSFTPD_USER" "/home/$VSFTPD_USER/ftp"
	start_templates "/vsftpd.cnf.template" "/etc/vsftpd/vsftpd.conf"
	exec vsftpd /etc/vsftpd/vsftpd.conf

}

init_vsftpd $@

if [ "$1" = "vsftpd" ]; then
	init_vsftpd $@
else
	exec "$@"
fi
