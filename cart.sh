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
dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "nodejs module disabled"
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "nodejs-18 module enabled" &>> $LOGFILE
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "nodeJS installed"
ID=$(id roboshop) 
if [ $ID -eq 0]
then echo "ID exists not required to create"
else useradd roboshop  &>> $LOGFILE
fi

if [ -d "/app" ]
then echo "/app already exists"
else mkdir "/app" &>> $LOGFILE
fi
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "downloaded .zip file from S3 builds"
cd /app &>> $LOGFILE
VALIDATE $? "directory APP change to /APP"
unzip /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "unzipped folder /tmp/user"
npm install &>> $LOGFILE
VALIDATE $? "Builds loaded in /app folder"
cp  /root/roboshop-shell/cart.service  /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "Copied cart.service file"
systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reloaded"
systemctl enable cart  &>> $LOGFILE
VALIDATE $? "cart service enabled"
systemctl start cart &>> $LOGFILE
VALIDATE $? "cart service started"
systemctl status cart
