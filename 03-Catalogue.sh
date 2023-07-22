
echo -e "\e[31m>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.conf /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[33m>>>>>>>>>> Install Nodejs File Content<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[34m>>>>>>>>>> Useradd to Service <<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[35m>>>>>>>>>> Remove previous file from the application  <<<<<<<<<<\e[0m"

#rm -rf /app

echo -e "\e[36m>>>>>>>>>> Create Directory  <<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[31m>>>>>>>>>> Catalogue Source File   <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[32m>>>>>>>>>> Extract Source File   <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[33m>>>>>>>>>> Move to Directory   <<<<<<<<<<\e[0m"

cd /app

echo -e "\e[34m>>>>>>>>>> Install dependent files  <<<<<<<<<<\e[0m"

npm install

echo -e "\e[35m>>>>>>>>>> Install mongodb  <<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>> Create mongodb Schema   <<<<<<<<<<\e[0m"
mongo --host mongodb.ndevops.online </app/schema/catalogue.js

echo -e "\e[31m>>>>>>>>>> Enable an Restart   <<<<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue