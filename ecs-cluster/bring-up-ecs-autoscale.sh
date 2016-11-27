#!/bin/bash
echo "Starting Basition Host"
./start-basition.sh
echo "Adjusting ECS AutoScale to 2 instances"
aws autoscaling update-auto-scaling-group --auto-scaling-group-name 'mrgEcs-ECS-EAD6X053A0KG-ECSAutoScalingGroup-WX6M6HY0SCJW' \
    --min-size 1 --max-size 2 --desired-capacity 2