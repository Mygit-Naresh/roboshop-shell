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
dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "disabled mysql module"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "Coped mysql repo file to /etc/yum.repos.d/mysql.repo"
dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "Installed mysql server" 
systemctl enable mysqld  &>> $LOGFILE
VALIDATE $? "enabled mysql deamon"
systemctl start mysqld  &>> $LOGFILE
VALIDATE $? "started mysql service"
mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "mysql set root password"  
mysql -uroot -pRoboShop@1 &>> $LOGFILE
VALIDATE $? "connecting mysql with root"
