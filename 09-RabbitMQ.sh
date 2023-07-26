curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

rabbitmq_password=$1
if [-z "${rabbitmq_password}"]; then
  echo Input Password is Missing
  exit 1
if

yum install rabbitmq-server -y

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

rabbitmqctl add_user roboshop ${rabbitmq_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

