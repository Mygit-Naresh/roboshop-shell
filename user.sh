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
fi
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
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "downloaded .zip file from roboshop builds"
cd /app &>> $LOGFILE
VALIDATE $? "directory APP change to /APP"
unzip /tmp/user.zip &>> $LOGFILE
VALIDATE $? "unzipped folder /tmp/user"
npm install &>> $LOGFILE
VALIDATE $? "Builds loaded in /App folder"
cp  /root/roboshop-shell/user.service  /etc/systemd/system/user.service &>> $LOGFILE
VALIDATE $? "Copied user.service file"
systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reloaded"
systemctl enable user &>> $LOGFILE
VALIDATE $? "User service enabled"
systemctl start user &>> $LOGFILE
VALIDATE $? "User service started"
systemctl status user 
cp /root/roboshop-shell/mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "mongo.repo loaded to /etc/yum.repos.d/mongo.repo"
dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "mongodb client installed"
mongo --host mongodb.eternaltrainings.online </app/schema/user.js &>> $LOGFILE
VALIDATE $? "mongodb schema loaded" 
