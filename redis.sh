#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$0-$TIMESTAMP.log
if [ $ID -ne 0 ]
then echo -e "your not authorized to install"
exit 1
else echo -e "your a root user"
fi
VALIDATE(){
if [ $1 -eq 0 ]
then
echo -e "$G $2 $N"
else
echo -e "$R Please check there is some issues $N"
exit 1
fi
}

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "installed remi repo .rpm file from internet"
dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "Enable module 6.2 redis" &>> $LOGFILE
dnf install redis -y &>> $LOGFILE
VALIDATE $? "install redis"
sed -i 's/127.0.0.1/0.0.0.0/g'  /etc/redis.conf &>> $LOGFILE
VALIDATE $? "Local IP replaced with 0.0.0.0 in /etc/redis.conf"
sed -i 's/127.0.0.1/0.0.0.0/g'  /etc/redis/redis.conf &>> $LOGFILE
VALIDATE $? "Local IP replaced with 0.0.0.0 in /etc/redis/redis.conf"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "Enable redis server"

systemctl start redis &>> $LOGFILE
VALIDATE $? "started redis server"

systemctl status redis

