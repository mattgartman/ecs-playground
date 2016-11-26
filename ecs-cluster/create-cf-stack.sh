#!/bin/bash
CF_STACKNAME='mrgEcs'
CF_STACK_S3_URL='https://s3.amazonaws.com/cf-template-ecs-mrg123'
CF_KEYPAIRNAME='mrgEcsKeyPair'
CF_BASTION_HOST_SECURITY_GROUP_NAME='sg-e0ad3c9d'

if aws cloudformation describe-stacks --stack-name $CF_STACKNAME 2>&1 |grep -q 'does not exist'; then
    echo 'creating new stack' 
    aws cloudformation create-stack --stack-name $CF_STACKNAME \
        --template-body $CF_STACK_S3_URL/master.yaml \
        --parameters ParameterKey=s3BucketUrl,ParameterValue=$CF_STACK_S3_URL ParameterKey=KeyPairName,ParameterValue=$CF_KEYPAIRNAME \
        --capabilities 'CAPABILITY_NAMED_IAM'
else
    echo 'updating stack'
        aws cloudformation update-stack --stack-name $CF_STACKNAME \
        --template-body $CF_STACK_S3_URL/master.yaml \
        --parameters ParameterKey=s3BucketUrl,ParameterValue=$CF_STACK_S3_URL ParameterKey=KeyPairName,ParameterValue=$CF_KEYPAIRNAME ParameterKey=BastionHostSecurityGroupName,ParameterValue=$CF_BASTION_HOST_SECURITY_GROUP_NAME \
        --capabilities 'CAPABILITY_NAMED_IAM'
fi