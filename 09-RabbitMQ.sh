rabbitmq_password=$1
if [ -z "${rabbitmq_password}" ]; then
  echo Input Password is Missing
  exit 1
fi


echo -e "\e[34m>>>>>>>>>> Installing Service <<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash


echo -e "\e[34m>>>>>>>>>> Installing Rabbitmq Service <<<<<<<<<<\e[0m"
yum install rabbitmq-server -y


 if [ $? -ne 0 ]; then
     rabbitmqctl add_user roboshop ${rabbitmq_password}
  fi

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

systemctl enable rabbitmq-server
systemctl restart rabbitmq-server