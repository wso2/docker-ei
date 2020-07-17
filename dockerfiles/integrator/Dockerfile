# ------------------------------------------------------------------------
#
# Copyright 2017 WSO2, Inc. (http://wso2.com)
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
#
# ------------------------------------------------------------------------

# set to latest Ubuntu LTS
FROM ubuntu:16.04
MAINTAINER WSO2 Docker Maintainers "dev@wso2.org"

# set user configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# build arguments for WSO2 product installation
ARG WSO2_SERVER_NAME=wso2ei
ARG WSO2_SERVER_VERSION=6.1.1
ARG WSO2_SERVER_REPOSITORY=product-ei
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_SERVER_DIST_URL
# set jdk configurations
ARG JDK_NAME=jdk-8u251-linux-x64.tar.gz
ARG JAVA_HOME=${USER_HOME}/java
ARG JDK_URL
# build arguments for external artifacts
ARG MYSQL_CONNECTOR_VERSION=5.1.49
ARG SECURE_VAULT_VERSION=1.0.0
ARG ANDES_CLIENT_VERSION=3.2.19
ARG GERONIMO_JMS_VERSION=1.1.0.wso2v1
# build argument for MOTD
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of a WSO2 product, running with its latest GA release \n\
which is under the Apache License, Version 2.0. \n\
Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"

# create a user group and a user
RUN groupadd --system -g ${USER_GROUP_ID} ${USER_GROUP} && \
    useradd --system --create-home --home-dir ${USER_HOME} --no-log-init -g ${USER_GROUP_ID} -u ${USER_ID} ${USER} \
    && echo '[ ! -z "${TERM}" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc; echo "${MOTD}" > /etc/motd

# install required packages
RUN \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --no-install-suggests \
        curl \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# installe Oracle JDK
RUN \
    mkdir -p ${JAVA_HOME} \
    && wget --no-check-certificate -O ${JDK_NAME} ${JDK_URL} \
    && tar -xf ${JDK_NAME} -C ${JAVA_HOME} --strip-components=1 \
    && chown wso2carbon:wso2 -R ${JAVA_HOME} \
    && rm -f ${JDK_NAME}

# add the WSO2 product distribution to user's home directory
RUN \
    wget --no-check-certificate -O ${WSO2_SERVER}.zip "${WSO2_SERVER_DIST_URL}" \
    && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
    && chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}

# add MySQL JDBC connector to server home as a third party library
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${WSO2_SERVER_HOME}/lib

# add secure vault, andes client and geronimo jms libraries to server home for the communication between Integrator and Message Broker
ADD --chown=wso2carbon:wso2 http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/securevault/org.wso2.securevault/${SECURE_VAULT_VERSION}/org.wso2.securevault-${SECURE_VAULT_VERSION}.jar ${WSO2_SERVER_HOME}/lib
ADD --chown=wso2carbon:wso2 http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/andes/wso2/andes-client/${ANDES_CLIENT_VERSION}/andes-client-${ANDES_CLIENT_VERSION}.jar ${WSO2_SERVER_HOME}/lib
ADD --chown=wso2carbon:wso2 http://maven.wso2.org/nexus/content/groups/wso2-public/org/apache/geronimo/specs/wso2/geronimo-jms_1.1_spec/${GERONIMO_JMS_VERSION}/geronimo-jms_1.1_spec-${GERONIMO_JMS_VERSION}.jar ${WSO2_SERVER_HOME}/lib

# set the user and work directory
USER ${USER}
WORKDIR ${USER_HOME}

# set environment variables
ENV JAVA_HOME=${JAVA_HOME} \
    PATH=$JAVA_HOME/bin:$PATH \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

# expose integrator ports
EXPOSE 8280 8243 9443

# set entrypoint to integrator startup script
ENTRYPOINT ${WSO2_SERVER_HOME}/bin/integrator.sh
