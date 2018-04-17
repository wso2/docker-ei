#!/bin/sh
# ------------------------------------------------------------------------
# Copyright 2018 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------
set -e

# product profile variable
wso2_server_profile=integrator

# custom WSO2 non-root user and group variables
user=wso2carbon
group=wso2

# file path variables
volumes=${WORKING_DIRECTORY}/volumes
k8s_volumes=${WORKING_DIRECTORY}/kubernetes-volumes

# capture the Docker container IP from the container's /etc/hosts file
docker_container_ip=$(awk 'END{print $1}' /etc/hosts)

# check if the WSO2 non-root user has been created
! getent passwd ${user} >/dev/null 2>&1 && echo "WSO2 Docker non-root user does not exist" && exit 1

# check if the WSO2 non-root group has been created
! getent group ${group} >/dev/null 2>&1 && echo "WSO2 Docker non-root group does not exist" && exit 1

# check if the WSO2 non-root user home exists
test ! -d ${WORKING_DIRECTORY} && echo "WSO2 Docker non-root user home does not exist" && exit 1

# check if the WSO2 product home exists
test ! -d ${WSO2_SERVER_HOME} && echo "WSO2 Docker product home does not exist" && exit 1

# check if any changed configuration files have been mounted, using K8s ConfigMap volumes

# since, K8s does not support building ConfigMaps recursively from a directory, each folder has been separately
# mounted in the form of a K8s ConfigMap volume
# yet, only files mounted at <WSO2_USER_HOME>/volumes will be copied into the product pack
# hence, the files that were originally mounted using K8s ConfigMap volumes, need to be copied into <WSO2_USER_HOME>/volumes
if test -d ${k8s_volumes}/${wso2_server_profile}/conf; then
    # if a ConfigMap volume containing WSO2 configuration files has been mounted
    test ! -d ${volumes}/conf && mkdir -p ${volumes}/conf
    cp -rL ${k8s_volumes}/${wso2_server_profile}/conf/* ${volumes}/conf
fi

if test -d ${k8s_volumes}/${wso2_server_profile}/conf-axis2; then
    # if a ConfigMap volume containing WSO2 axis2 configuration files has been mounted
    test ! -d ${volumes}/conf/axis2 && mkdir -p ${volumes}/conf/axis2
    cp -rL ${k8s_volumes}/${wso2_server_profile}/conf-axis2/* ${volumes}/conf/axis2
fi

if test -d ${k8s_volumes}/${wso2_server_profile}/conf-datasources; then
    # if a ConfigMap volume containing WSO2 data source configuration files has been mounted
    test ! -d ${volumes}/conf/datasources && mkdir -p ${volumes}/conf/datasources
    cp -rL ${k8s_volumes}/${wso2_server_profile}/conf-datasources/* ${volumes}/conf/datasources
fi

# copy configuration changes and external libraries

# check if any changed configuration files have been mounted
# if any file changes have been mounted, copy the WSO2 configuration files recursively
test -d ${volumes}/conf && cp -r ${volumes}/conf/* ${WSO2_SERVER_HOME}/conf

# check if the external library directories have been mounted
# if mounted, recursively copy the external libraries to original directories within the product home
test -d ${volumes}/dropins && cp -r ${volumes}/dropins/* ${WSO2_SERVER_HOME}/dropins
test -d ${volumes}/extensions && cp -r ${volumes}/extensions/* ${WSO2_SERVER_HOME}/extensions
test -d ${volumes}/lib && cp -r ${volumes}/lib/* ${WSO2_SERVER_HOME}/lib

# make any runtime or node specific configuration changes
# for example, setting container IP in relevant configuration files

# set the Docker container IP as the `localMemberHost` under axis2.xml clustering configurations (effective only when clustering is enabled)
sed -i "s#<parameter\ name=\"localMemberHost\".*<\/parameter>#<parameter\ name=\"localMemberHost\">${docker_container_ip}<\/parameter>#" ${WSO2_SERVER_HOME}/conf/axis2/axis2.xml

# start the WSO2 Carbon server profile
sh ${WSO2_SERVER_HOME}/bin/${wso2_server_profile}.sh
