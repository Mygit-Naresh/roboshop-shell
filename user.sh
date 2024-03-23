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
dnf module disable nodejs -y
VALIDATE $? "nodejs module disabled"
dnf module enable nodejs:18 -y
VALIDATE $? "nodejs-18 module enabled"
dnf install nodejs -y
VALIDATE $? "nodeJS installed"
ID=$(id roboshop)
if [ $ID -eq 0]
then echo "ID exists not required to create"
else useradd roboshop
fi

if [ -d "/App" ]
then echo "already exists"
else mkdir "/App"


mkdir /app
