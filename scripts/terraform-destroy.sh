#!/bin/bash
#export AWS_DEFAULT_PROFILE=terraform
#export AWS_PROFILE=terraform
#export AWS_DEFAULT_PROFILE="default"
export AWS_PROFILE="default"
AWS_PROFILE="default"
export AWS_DEFAULT_REGION="ap-southeast-2"
#AWS_SECRET_ACCESS_KEY=$(aws sts assume-role --role-arn arn:aws:iam::279459402216:role/vha-dslave-instance-role --role-session-name jenkins | grep -w 'SecretAccessKey' | awk '{print $2}' | sed 's/\"//g;s/\,//')
#AWS_ACCESS_KEY_ID=$(aws sts assume-role --role-arn arn:aws:iam::279459402216:role/vha-dslave-instance-role --role-session-name jenkins | grep -w 'AccessKeyId' | awk '{print $2}' | sed 's/\"//g;s/\,//')
#echo $AWS_ACCESS_KEY_ID
#echo $AWS_SECRET_ACCESS_KEY
#export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
#export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
terraform destroy -auto-approve