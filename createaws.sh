#!/bin/bash
INSTANCES=("mongodb" "redis" "rabbitMQ" "mysql" "user" "catalogue" "payment" "shipping" "web")
HOSTEDZONE="Z101265833JA5X90XBKK8"
for INSTANCE  in "${INSTANCES[@]}"
do
if [ $INSTANCE = "mongodb" ] || [ $INSTANCE = "redis" ] || [ $INSTANCE = "shipping" ]
then
aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t3.small --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text
else
aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t2.micro --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text
fi
echo "$INSTANCE created in aws successfully"
IPADDRESS=$(aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type t2.micro --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text)
echo "$INSTANCE = $IPADDRESS"

aws route53 change-resource-record-sets \
--hosted-zone-id YOUR_HOSTED_ZONE_ID \
--change-batch '
    {
        "Comment": "Creating a record set for roboshop projetc and domain eternaltraings.line"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$INSTANCE'.eternaltrainings.online"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IPADDRESS'"
            }]
        }
        }]
    }
        '

done


