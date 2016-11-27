#!/bin/bash
echo "Stopping basition host"
./stop-basition.sh
echo "Adjusting ECS auto scale group to 0 instances"
aws autoscaling update-auto-scaling-group --auto-scaling-group-name 'mrgEcs-ECS-EAD6X053A0KG-ECSAutoScalingGroup-WX6M6HY0SCJW' \
    --min-size 0 --max-size 0 --desired-capacity 0