create_dns_record.yaml="
Changes:
  - Action: CREATE
    ResourceRecordSet:
      Name: test.eternaltrainings.online
      Type: A
      TTL: 10
      ResourceRecords:
        - Value: 172.2.20.10
        "

#!/bin/bash

# Variables
HOSTED_ZONE_ID="Z101265833JA5X90XBKK8"
YAML_FILE="create_dns_record.yaml"

# Create DNS record using AWS CLI
aws route53 change-resource-record-sets \
--hosted-zone-id "$HOSTED_ZONE_ID" \
--cli-input-yaml file://"$YAML_FILE"
