#!/bin/bash
INSTANCES=("mongodb" "redis" "rabbitMQ" "mysql" "user" "catalogue" "payment" "shipping" "web")
for INSTANCE  in "${INSTANCES[@]}"
do
echo $INSTANCE is creating
if [ $INSTANCE = "mongodb" ] || [ $INSTANCE = "redis" ] || [ $INSTANCE = "shipping" ]
then
aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t3.small --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text
else
aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t2.micro --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text
fi
echo "$INSTANCE created in aws successfully"
done


