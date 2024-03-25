#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$0-$TIMESTAMP.log
ID=$(id -u)
if [ $ID -ne 0 ]
then echo -e "your not authorized to install"
exit 1
else echo -e "your a root user"
fi
VALIDATE(){
if [ $1 -eq 0 ]
then
echo "$G $2 $N"
else
echo -e "$R Please check there is some issues $N"
exit 1
fi
}
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
VALIDATE $?  "download .rmp package from erlang "

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
VALIDATE $?  "download .rmp package from rabbitmq"

dnf install rabbitmq-server -y 
VALIDATE $?  "Install rabbitmq server"
systemctl enable rabbitmq-server
VALIDATE $?  "Install rabbitmq service enable"
systemctl start rabbitmq-server 
VALIDATE $?  "Install rabbitmq service started"
rabbitmqctl add_user roboshop roboshop123
VALIDATE $?  "added user and pwd"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $?  "Required Permissions are set"