#!/bin/bash
INSTANCES=("mongodb" "redis" "rabbitMQ" "mysql" "user" "catalogue" "payment" "shipping" "web")
echo "${INSTANCES[@]}"
for INSTANCE  in $INSTANCES
do
if [ $INSTANCE = "mongodb" ] && [ $INSTANCE = "redis" ] && [ $INSTANCE = "shipping" ]
then
aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t3.small --security-group-ids sg-09806393e77f11a3e
else
aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t2.micro --security-group-ids sg-09806393e77f11a3e
fi
done
echo "All $INSTANCE are created in aws successfully"