#!/bin/bash
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -f integrator2.rsa -t rsa -N ''
sshpass -p "rsyncuser" ssh-copy-id -o "StrictHostKeyChecking no"  -i ~/.ssh/integrator2.rsa.pub rsyncuser@integrator1

while true 
do
rsync --delete -arve 'ssh -i integrator2.rsa -o StrictHostKeyChecking=no' rsyncuser@integrator1:/mnt/wso2ei-6.1.1/repository/deployment/server/ /mnt/wso2ei-6.1.1/repository/deployment/server/
sleep 10
done
