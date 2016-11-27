#!/bin/bash
ssh-add ~/keys/mrgEcsKeyPair.pem
ssh -A -i ~/keys/mrgEcsKeyPair.pem ec2-user@$(aws ec2 describe-instances --instance-id i-0f96ff6ccaf48888c --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
