dir=/home/$VSFTPD_USER/ftp/files/

adduser --disabled-password "$VSFTPD_USER"
echo "$VSFTPD_USER":"$VSFTPD_PASS" | chpasswd

usermod --home $dir "$VSFTPD_USER"
chown "$VSFTPD_USER":"$VSFTPD_USER" $dir 

echo "$VSFTPD_USER" > /etc/vsftpd/vsftpd.allowed_users

exec vsftpd /etc/vsftpd/vsftpd.conf
