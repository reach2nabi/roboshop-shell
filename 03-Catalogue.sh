
echo -e "\e[31>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service
cp mongo.conf /etc/yum.repos.d/mongo.repo

echo -e "\e[32>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[33>>>>>>>>>> Install Nodejs File Content<<<<<<<<<<\e[0m"
yum install nodejs -y

echo  "\e[34>>>>>>>>>> Useradd to Service <<<<<<<<<<\e[0m"
useradd roboshop

echo  "\e[35>>>>>>>>>> Remove previous file from the application  <<<<<<<<<<\e[0m"

#rm -rf /app

echo  "\e[36>>>>>>>>>> Create Directory  <<<<<<<<<<\e[0m"
mkdir /app

echo  "\e[31>>>>>>>>>> Catalogue Source File   <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo  "\e[32>>>>>>>>>> Extract Source File   <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo  "\e[33>>>>>>>>>> Move to Directory   <<<<<<<<<<\e[0m"

cd /app

echo  "\e[34>>>>>>>>>> Install dependent files  <<<<<<<<<<\e[0m"

npm install

echo  "\e[35>>>>>>>>>> Install mongodb  <<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo  "\e[36>>>>>>>>>> Create mongodb Schema   <<<<<<<<<<\e[0m"
mongo --host mongodb.ndevops.online </app/schema/catalogue.js

echo  "\e[31>>>>>>>>>> Enable an Restart   <<<<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue