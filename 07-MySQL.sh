cp mysql.repo /etc/yum.repos.d/mysql.repo
mysql_password=$1
if[-z "{mysql_password}"]; then
  echo Input password is missing
  exit 1
fi

yum module disable mysql -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld

mysql_secure_installation --set-root-pass {mysql_password}
#RoboShop@1