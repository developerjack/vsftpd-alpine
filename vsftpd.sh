#!/bin/sh

# Create user and add it to the 'ftp' group
adduser -G ftp -s /bin/sh -D $FTP_USER

# Set password of the user
echo "$FTP_USER:$FTP_PASS" | chpasswd

if grep -q '# Lines added' /etc/vsftpd/vsftpd.conf; then
  echo "Lines added"
else
  # Add config lines to vsftpd.conf
  echo "# Lines added
  seccomp_sandbox=NO
  local_enable=YES
  write_enable=YES
  chroot_local_user=YES
  passwd_chroot_enable=YES
  allow_writeable_chroot=YES
  
  ftpd_banner=Welcome to vsftpd
  max_clients=10
  max_per_ip=5
  local_umask=022
  
  pasv_enable=$PASV_ENABLE
  pasv_max_port=$PASV_MAX_PORT
  pasv_min_port=$PASV_MIN_PORT
  pasv_address=$PASV_ADDRESS
  
  anonymous_enable=$ANON_ENABLE
  no_anon_password=$NO_ANON_PASSWD
  anon_root=$ANON_ROOT
  
  ssl_enable=$SSL_ENABLE
  rsa_private_key_file=$RSA_PRIVATE_KEY_FILE
  rsa_cert_file=$RSA_CERT_FILE
  " >> /etc/vsftpd/vsftpd.conf
fi


/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
