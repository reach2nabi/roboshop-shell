rabbitmq_password=$1
if [ -z "${rabbitmq_password}" ]; then
  echo Input Password is Missing
  exit 1
fi

component=payment
source common.sh

func_python
