#!/bin/bash
S3_BUCKET="cf-template-ecs-mrg123"


if aws s3 ls $S3_BUCKET 2>&1 | grep -q 'NoSuchBucket'; then
    echo "Creating $S3_BUCKET"
    aws s3 mb s3://$S3_BUCKET
else
    echo "$S3_BUCKET exists; moving on"
fi; 


for file in $(find -name '*.yaml'); do 
    aws s3 cp $file s3://$S3_BUCKET/${file:2} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
done;