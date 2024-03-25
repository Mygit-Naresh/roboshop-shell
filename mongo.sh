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
if [ $1 -ne 0 ]
then echo -e "$R There is some issue please check $N"
exit 1
else echo -e "$G $2 $N"
fi
}

cp /root/roboshop-shell/mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copied mongo repo file successfully"

dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "mongodb installed successfully"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enabled mongodb service"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "started mongodb service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Replaced local host IP to 0.0.0.0"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarted mongodb service"

netstat -lntp