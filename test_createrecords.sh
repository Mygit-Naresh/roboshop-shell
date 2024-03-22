CHANGE_BATCH=$(Changes: - Action: CREATE ResourceRecordSet: Name: test.eternaltrainings.online Type: A TTL: 10 ResourceRecords: - Value: 172.21.0.1)

aws route53 change-resource-record-sets \
--hosted-zone-id Z101265833JA5X90XBKK8 \
--change-batch "$CHANGE_BATCH"