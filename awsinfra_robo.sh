#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
INSTANCES=("mongodb" "redis" "rabbitmq" "mysql" "user" "catalogue" "payment" "shipping" "cart" "web")
#INSTANCES=("mongodb" "catalogue" "web")
AMI="ami-0f3c7d07486cad139"
SECURITY_GROUP="sg-09806393e77f11a3e"
HOSTED_ZONE="Z101265833JA5X90XBKK8"
DOMAIN_NAME="eternaltrainings.online"
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

IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE  --security-group-ids $SECURITY_GROUP --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE"}]" --query 'Instances[0].PrivateIpAddress' --output text)

echo -e "$INSTANCE = $IP_ADDRESS"

aws route53 change-resource-record-sets \
--hosted-zone-id $HOSTED_ZONE \
--change-batch '
    {
        "Comment": "Creating a record set for roboshop project infra"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$INSTANCE.$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
     '

echo -e "$G DNS Record in R53 created for $INSTANCE and IP and host is $IP_ADDRESS and $INSTANCE.$DOMAIN_NAME $N"

done
