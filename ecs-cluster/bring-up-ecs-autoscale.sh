#!/bin/bash
echo "Starting Basition Host"
./start-basition.sh
echo "starting jenkins"
./start-jenkins.sh
echo "Adjusting ECS AutoScale to 2 instances"
aws autoscaling update-auto-scaling-group --auto-scaling-group-name 'mrgEcs-ECS-18PJ353V04G6A-ECSAutoScalingGroup-Z33MMUIVTWHF' \
    --min-size 1 --max-size 2 --desired-capacity 2