#!/bin/bash
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -f analytics2.rsa -t rsa -N ''
sshpass -p "rsyncuser" ssh-copy-id -o "StrictHostKeyChecking no"  -i ~/.ssh/analytics2.rsa.pub rsyncuser@analytics1

while true 
do
rsync --delete -arve 'ssh -i analytics2.rsa -o StrictHostKeyChecking=no' rsyncuser@analytics1:/mnt/wso2ei-6.1.1/wso2/analytics/repository/deployment/server/ /mnt/wso2ei-6.1.1/wso2/analytics/repository/deployment/server/
sleep 10
done
