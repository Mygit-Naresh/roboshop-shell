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
echo -e "$G $2 $N"
else
echo -e "$R Please check there is some issues $N"
exit 1
}
dnf install nginx -y &>> $LOGFILE
VALIDATE $? "nginx installed"
systemctl enable nginx &>> $LOGFILE
VALIDATE $? "nginx enabled"
systemctl start nginx &>> $LOGFILE
VALIDATE $? "nginx started"
rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "removed default content in html" 
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "downloaded web content in zip"

unzip /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzip web content"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf  &>> $LOGFILE
VALIDATE $? "copied roboshop.conf file to /etc"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "change directory to /usr/share/nginx/html"
systemctl restart nginx  &>> $LOGFILE
VALIDATE $? "nginx restarted"
systemctl status nginx