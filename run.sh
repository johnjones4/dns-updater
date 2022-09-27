#!/bin/bash

while :
do
  IP_ADDRESS=$(dig +short A myip.opendns.com @resolver1.opendns.com)
  echo $IP_ADDRESS
  if [ "$IP_ADDRESS" == "" ]; then
    exit 1
  fi
  
  sed "s/IP_ADDRESS/$IP_ADDRESS/g" change_template.json > change_batch.json
  
  export AWS_PAGER=""
  aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch file://change_batch.json
  if [ "$?" != "0" ]; then
    exit 1
  fi

  rm change_batch.json
  sleep 86400
done
