#!/bin/bash
eval $(ssh-agent -s)
ssh-add ~/keys/mrgEcsKeyPair.pem
ssh -A -i ~/keys/mrgEcsKeyPair.pem ec2-user@$(aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
