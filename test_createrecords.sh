#!/bin/bash

# Variables
HOSTED_ZONE_ID="Z101265833JA5X90XBKK8"
YAML_FILE="create_record.yml"

# Create DNS record using AWS CLI
aws route53 change-resource-record-sets \
--hosted-zone-id "$HOSTED_ZONE_ID" \
--cli-input-yaml file://"$YAML_FILE"
