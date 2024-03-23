#!/bin/bash
INSTANCES=("mongodb" "redis" "rabbitMQ" "mysql" "user" "catalogue" "payment" "shipping" "web")
HOSTEDZONE="Z101265833JA5X90XBKK8"
T2_INSTANCE_TYPE="t2.micro"
T3_INSTANCE_TYPE="t3.small"
for INSTANCE  in "${INSTANCES[@]}"
do
echo -e "Creating $INSTANCE"
if [ $INSTANCE = "mongodb" ] || [ $INSTANCE = "redis" ] || [ $INSTANCE = "shipping" ]
then
T3_IPADDRESS=$(aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $T3_INSTANCE_TYPE --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text)
else
T2_IPADDRESS=$(aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $T2_INSTANCE_TYPE --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text)
fi


if [ $T3_INSTANCE_TYPE = $T3_IPADDRESS  ] then

aws route53 change-resource-record-sets \
--hosted-zone-id Z101265833JA5X90XBKK8 \
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
                "Value"         : "'$T3_IPADDRESS'"
            }]
        }
        }]
    }
        '

else
aws route53 change-resource-record-sets \
--hosted-zone-id Z101265833JA5X90XBKK8 \
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
                "Value"         : "'$T2_IPADDRESS'"
            }]
        }
        }]
    }
        '


done

