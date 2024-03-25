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
else echo -e "your a root user"
fi
VALIDATE(){
if [ $1 -ne 0 ]
then echo -e "$R $3 $N"
else echo -e  "$G $2 $N"
fi
}
dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabled nodejs" "Unsuccessfull"
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabled nodejs" "Unsuccessfull"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installed nodejs"
id roboshop
if [ $? -ne 0 ]
then
useradd roboshop
VALIDATE $? "roboshop user creation"
else
echo -e "roboshop user already exist $Y SKIPPING $N"
fi
id roboshop
VALIDATE $? "Checking if roboshop id is created successfully or not"
if [ -d /app ]
then rm -rf /app
fi
mkdir -p /app &>> LOGFILE
VALIDATE $? "Created app folder"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "download catalogue.zip in /tmp/catalogue folder"
cd /app &>> $LOGFILE
VALIDATE $? "Changed directory to /app"
unzip -o /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "unzip catalogue.zip files in /tmp"
npm install &>> $LOGFILE
VALIDATE $? "Installed dependencies"
cp /root/roboshop-shell/catalogue.service  /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "Copied catalogue.service to /etc/systemd/system/catalogue.service"
systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reloaded"
systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enable catalogue service"
systemctl start catalogue &>> $LOGFILE
VALIDATE $? "Started catalogue service"
systemctl status  catalogue &>> $LOGFILE
cp /root/roboshop-shell/mongo.repo  /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copied mongo.repo file to /etc/yum.repos.d/mongo.repo"
dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Mongodb client installed"
mongo --host 172.31.29.97 </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "Conneted to mongodb host and loaded schema"
systemctl status  catalogue