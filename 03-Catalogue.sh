
echo  ">>>>>>>>>> Nodejs File Content<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.conf /etc/yum.repos.d/mongo.repo

echo  ">>>>>>>>>> Nodejs File Content<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo  ">>>>>>>>>> Install Nodejs File Content<<<<<<<<<<"
yum install nodejs -y

echo  ">>>>>>>>>> Useradd to Service <<<<<<<<<<"
useradd roboshop

echo  ">>>>>>>>>> Remove previous file from the application  <<<<<<<<<<"

#rm -rf /app

echo  ">>>>>>>>>> Create Directory  <<<<<<<<<<"
mkdir /app

echo  ">>>>>>>>>> Catalogue Source File   <<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo  ">>>>>>>>>> Extract Source File   <<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip

echo  ">>>>>>>>>> Move to Directory   <<<<<<<<<<"

cd /app

echo  ">>>>>>>>>> Install dependent files  <<<<<<<<<<"

npm install

echo  ">>>>>>>>>> Install mongodb  <<<<<<<<<<"
yum install mongodb-org-shell -y

echo  ">>>>>>>>>> Create mongodb Schema   <<<<<<<<<<"
mongo --host mongodb.ndevops.online </app/schema/catalogue.js

echo  ">>>>>>>>>> Enable an Restart   <<<<<<<<<<"

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue