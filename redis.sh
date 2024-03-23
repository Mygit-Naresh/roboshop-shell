#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$0-$TIMESTAMP.log
VALIDATE(){
if [ $1 -eq 0 ]
then
echo "$G $2 $N"
else
echo "Please check there is some issues"
}

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
VALIDATE $? "installed redis"
dnf module enable redis:remi-6.2 -y
VALIDATE $? "Enable module 6.2 redis"
dnf install redis -y
VALIDATE $? "install redis"
sed -i /s/127.0.0.1/0.0.0.0/g  /etc/redis.conf
VALIDATE $? "Local IP replaced with 0.0.0.0 in /etc/redis.conf"
sed -i /s/127.0.0.1/0.0.0.0/g  /etc/redis/redis.conf
VALIDATE $? "Local IP replaced with 0.0.0.0 in /etc/redis/redis.conf"

systemctl enable redis
VALIDATE $? "Enable redis server"

systemctl start redis
VALIDATE $? "started redis server"

systemctl status redis

