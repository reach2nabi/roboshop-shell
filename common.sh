log=/tmp/roboshop.log

func_nodejs(){
echo -e "\e[31m>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
cp mongo.conf /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[32m>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[33m>>>>>>>>>> Install Nodejs File Content<<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}

echo -e "\e[34m>>>>>>>>>> Install dependent files  <<<<<<<<<<\e[0m"
npm install &>>${log}

echo -e "\e[35m>>>>>>>>>> Install mongodb  <<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>> Create mongodb Schema   <<<<<<<<<<\e[0m"
mongo --host mongodb.ndevops.online </app/schema/${component}.js &>>${log}

func_systemd
}

func_appprereq(){
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[34m>>>>>>>>>> Useradd to Service <<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}

  echo -e "\e[35m>>>>>>>>>> Remove previous file from the application  <<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}

  echo -e "\e[36m>>>>>>>>>> Create Directory  <<<<<<<<<<\e[0m"
  mkdir /app &>>${log}

  echo -e "\e[31m>>>>>>>>>> ${component} Source File   <<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

  echo -e "\e[32m>>>>>>>>>> Extract Source File   <<<<<<<<<<\e[0m"
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}

  echo -e "\e[33m>>>>>>>>>> Move to Directory   <<<<<<<<<<\e[0m"
  cd /app &>>${log}

}


func_systemd(){
echo -e "\e[31m>>>>>>>>>> Enable an Restart   <<<<<<<<<<\e[0m"  
systemctl daemon-reload &>>${log}
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}
}



func_java(){
  
echo -e "\e[31m>>>>>>>>>>  Install java    <<<<<<<<<<\e[0m"  
yum install maven -y &>>${log}

func_appprereq

echo -e "\e[31m>>>>>>>>>>  Install dependent packages    <<<<<<<<<<\e[0m"  
mvn clean package &>>${log}
mv target/${component}-1.0.jar ${component}.jar &>>${log}

echo -e "\e[31m>>>>>>>>>>  Install mysql    <<<<<<<<<<\e[0m"  
yum install mysql -y &>>${log}

echo -e "\e[31m>>>>>>>>>>  Install Schema    <<<<<<<<<<\e[0m"  
mysql -h mysql.ndevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

func_systemd
}

func_python(){
  echo -e "\e[31m>>>>>>>>>>  Install Python    <<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_appprereq

  echo -e "\e[31m>>>>>>>>>>  Build Service     <<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  
  func_systemd

  
}