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
echo -e "$G $2 $N"
else
echo -e "$R Please check there is some issues $N"
exit 1
fi
}
dnf install maven -y &>> $LOGFILE
VALIDATE $? "maven installed"
if [ $ID -eq 0 ]
then echo "ID exists not required to create"
else useradd roboshop  &>> $LOGFILE
fi
mkdir -p /app &>> $LOGFILE
VALIDATE $? "/app folder created"
cd /app &>> $LOGFILE
VALIDATE $? "changed directory /app"
curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
VALIDATE $? "builds downloaded in zip"
unzip /tmp/shipping.zip &>> $LOGFILE
VALIDATE $? "unzipped builds"
mvn clean package &>> $LOGFILE
VALIDATE $? "java package is ready"
mv /app/target/shipping-1.0.jar shipping.jar &>> $LOGFILE
VALIDATE $? "renamed .jar folder t0 shipping.jar"
cp /root/roboshop-shell/shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon reloaded"
systemctl enable shipping &>> $LOGFILE
VALIDATE $? "shipping service enabled"
systemctl start shipping &>> $LOGFILE
VALIDATE $? "shipping service started"
dnf install mysql -y &>> $LOGFILE
VALIDATE $? "mysql client installed"
mysql -h mysql.eternaltrainings.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE
VALIDATE $? "connected to mysql server and loaded schema"
systemctl restart shipping &>> $LOGFILE
VALIDATE $? "restarted shipping service"
systemctl status shipping