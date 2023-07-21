sudo rm -rf /etc/yum.repos.d/mongod*
sudo yum clean all

cp mono.repo /etc/yum.repos.d/mongo.repo

yum install mongodb-org -y
# Need to Update  listen address from 127.0.0.1 to 0.0.0.0 in

systemctl enable mongod
systemctl start mongod
systemctl restart mongod
