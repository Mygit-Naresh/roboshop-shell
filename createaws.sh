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
    INSTANCE_TYPE="t3.small"
else
    INSTANCE_TYPE="t2.micro"
fi

IP_ADDRESS=$(aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $INSTANCE_TYPE  --security-group-ids sg-09806393e77f11a3e --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text)

echo -e "$INSTANCE = $IP_ADDRESS"

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
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
     '
else

echo "Record created for $INSTANCE and Ip is $IP_ADDRESS"

done

