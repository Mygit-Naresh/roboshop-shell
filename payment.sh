#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$0-$TIMESTAMP.log
ID=$(id -u)
if [ $ID -ne 0 ]
then echo -e "$R your not authorized to install $N"
exit 1
else echo -e "$G your a root user $N"
fi
VALIDATE(){
if [ $1 -eq 0 ]
then
echo "$G $2 $N"
else
echo "$R Please check there is some issues $N"
exit 1
fi
}
dnf install python36 gcc python3-devel -y
VALIDATE "$?" "install pytho36"
if [ $ID -eq 0]
then echo "ID exists not required to create"
else useradd roboshop.python  &>> $LOGFILE
fi
mkdir -p /app_python &>> $LOGFILE
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
VALIDATE "$?" "download bild file payment.zip"
cd /app_python &>> $LOGFILE
unzip /tmp/payment.zip &>> $LOGFILE
VALIDATE "$?" "unzip payment.zip"
pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE "$?" "python dependencies installed"
cp /root/roboshop-shell/payment.service  /etc/systemd/system/payment.service &>> $LOGFILE
VALIDATE "$?" "copied payment.service to etc"
systemctl daemon-reload &>> $LOGFILE
VALIDATE "$?" "daemon reloading"
systemctl enable payment &>> $LOGFILE
VALIDATE "$?" "payment service enabled"
systemctl start payment &>> $LOGFILE
VALIDATE "$?" "payment service started"
systemctl status payment &>> $LOGFILE

