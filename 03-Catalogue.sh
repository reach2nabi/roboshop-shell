cp catalogue.service /etc/systemd/system/catalogue.service
cp Mongodb.repo /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop
mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install
systemctl daemon-reload

yum install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue