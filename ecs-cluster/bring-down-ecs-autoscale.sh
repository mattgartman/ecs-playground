#!/bin/bash
echo "Stopping basition host"
./stop-basition.sh
echo "stoping jenkins"
./stop-jenkins.sh
echo "Adjusting ECS auto scale group to 0 instances"
aws autoscaling update-auto-scaling-group --auto-scaling-group-name 'mrgEcs-ECS-18PJ353V04G6A-ECSAutoScalingGroup-Z33MMUIVTWHF' \
    --min-size 0 --max-size 0 --desired-capacity 0