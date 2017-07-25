#!/bin/bash
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -f business-process2.rsa -t rsa -N ''
sshpass -p "rsyncuser" ssh-copy-id -o "StrictHostKeyChecking no"  -i ~/.ssh/business-process2.rsa.pub rsyncuser@business-process1

while true 
do
rsync --delete -arve 'ssh -i business-process2.rsa -o StrictHostKeyChecking=no' rsyncuser@business-process1:/mnt/wso2ei-6.1.1/wso2/buisness-process/repository/deployment/server/ /mnt/wso2ei-6.1.1/wso2/buisness-process/repository/deployment/server/
sleep 10
done
