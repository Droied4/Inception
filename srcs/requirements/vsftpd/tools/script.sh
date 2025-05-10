#!/bin/bash

mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

# Add the USER, change his password and declare him as the owner of wordpress folder and all subfolders

# adduser sammy --disabled-password

# echo "sammy:123" | /usr/sbin/chpasswd

# echo "sammy" | tee -a /etc/vsftpd.userlist 


# mkdir /home/sammy/ftp


# chown nobody:nogroup /home/sammy/ftp
# chmod a-w /home/sammy/ftp

# mkdir /home/sammy/ftp/files
# chown sammy:sammy /home/sammy/ftp/files

sed -i "s/#write_enable=YES/write_enable=YES/1"   /etc/vsftpd.conf
sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/1"   /etc/vsftpd.conf

echo "
local_enable=YES
allow_writeable_chroot=YES
pasv_enable=YES
local_root=/home/sami/ftp
pasv_min_port=40000
pasv_max_port=40005
userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf


/usr/sbin/vsftpd
