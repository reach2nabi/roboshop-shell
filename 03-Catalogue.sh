cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.conf /etc/yum.repos.d/mongo.repo

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

useradd roboshop

rm -rf /app

mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

cd /app
npm install
systemctl daemon-reload

yum install mongodb-org-shell -y
mongo --host mongodb.ndevops.online </app/schema/catalogue.js

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue