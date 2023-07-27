log=/tmp/roboshop.log

func_exit_status(){
  if [$? -eq 0];then
      echo -e "\e[31m>>>>> FAILURE  <<<<<<\e[0m"
    else
      echo -e "\e[32m>>>>> SUCCESS <<<<<<\e[0m"
  fi
}

func_appprereq(){
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  func_exit_status

  echo -e "\e[34m>>>>>>>>>> Useradd to Service <<<<<<<<<<\e[0m"
  if [$? -eq 0]; then
    echo -e "\e[34m>>>>> User already Exist"
  else
     useradd roboshop &>>${log}
  fi
  func_exit_status

  echo -e "\e[35m>>>>>>>>>> Remove previous file from the application  <<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>> Create Directory  <<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  func_exit_status

  echo -e "\e[31m>>>>>>>>>> ${component} Source File   <<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[32m>>>>>>>>>> Extract Source File   <<<<<<<<<<\e[0m"
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[33m>>>>>>>>>> Move to Directory   <<<<<<<<<<\e[0m"
  cd /app &>>${log}
  func_exit_status
}

func_schema_setup(){
 if [ "${schema_type}" == "mongodb" ]; then
   echo -e "\e[35m>>>>>>>>>> Install mongodb  <<<<<<<<<<\e[0m"
   yum install mongodb-org-shell -y &>>${log}
    func_exit_status

   echo -e "\e[36m>>>>>>>>>> Create mongodb Schema   <<<<<<<<<<\e[0m"
   mongo --host mongodb.ndevops.online </app/schema/${component}.js &>>${log}
   func_exit_status
 fi

 if [ "${schema_type}"=="mysql" ]; then
  echo -e "\e[31m>>>>>>>>>>  Install mysql    <<<<<<<<<<\e[0m"
  yum install mysql -y &>>${log}
   func_exit_status

  echo -e "\e[31m>>>>>>>>>>  Install Schema    <<<<<<<<<<\e[0m"
  mysql -h mysql.ndevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
   func_exit_status
fi

}

func_systemd(){
echo -e "\e[31m>>>>>>>>>> Enable an Restart   <<<<<<<<<<\e[0m"
systemctl daemon-reload &>>${log}
systemctl enable ${component} &>>${log}
systemctl restart ${component} &>>${log}
 func_exit_status
}


func_nodejs(){
echo -e "\e[31m>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
cp mongo.conf /etc/yum.repos.d/mongo.repo &>>${log}
 func_exit_status
func_appprereq
echo -e "\e[32m>>>>>>>>>> Nodejs File Content<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
 func_exit_status

echo -e "\e[33m>>>>>>>>>> Install Nodejs File Content<<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}
 func_exit_status

echo -e "\e[34m>>>>>>>>>> Install dependent files  <<<<<<<<<<\e[0m"
npm install &>>${log}
 func_exit_status
func_schema_setup
func_systemd
}

func_java(){
echo -e "\e[31m>>>>>>>>>>  Install java    <<<<<<<<<<\e[0m"
yum install maven -y &>>${log}
 func_exit_status

func_appprereq

echo -e "\e[31m>>>>>>>>>>  Install dependent packages    <<<<<<<<<<\e[0m"  
mvn clean package &>>${log}
mv target/${component}-1.0.jar ${component}.jar &>>${log}
 func_exit_status

func_schema_setup
func_systemd
}


func_python(){
  echo -e "\e[31m>>>>>>>>>>  Install Python    <<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_exit_status
  func_appprereq

  sed -i "s/rabbitmq_password/${rabbitmq_password}/" /etc/systemd/system/${component}.service

  echo -e "\e[31m>>>>>>>>>>  Build Service     <<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status
  func_systemd

}