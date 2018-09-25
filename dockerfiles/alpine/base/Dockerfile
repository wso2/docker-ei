# ------------------------------------------------------------------------
#
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
#
# ------------------------------------------------------------------------

# set to latest Alpine
FROM openjdk:8u171-jdk-alpine3.8
MAINTAINER WSO2 Docker Maintainers "dev@wso2.org”

# set user configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}
# set dependant files directory
ARG FILES=./files
# set wso2 product configurations
ARG WSO2_SERVER=wso2ei
ARG WSO2_SERVER_VERSION=6.4.0
ARG WSO2_SERVER_DIST=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER_DIST}
ENV ENV=${USER_HOME}"/.ashrc"

# install required packages
RUN  apk add --update --no-cache \
     curl \
     netcat-openbsd && \
     rm -rf /var/cache/apk/*

# create a user group and a user
RUN  addgroup -g ${USER_GROUP_ID} ${USER_GROUP}; \
     adduser -u ${USER_ID} -D -g '' -h ${USER_HOME} -G ${USER_GROUP} ${USER} ;

RUN echo 'printf " Welcome to WSO2 Docker Resources \n\
    --------------------------------- \n\
    This image contains a WSO2 product released under Apache 2.0 license.\n\
    For more information, visit @ https://wso2.com \n"\' > "$ENV"

# create java prefs dir
# this is to avoid warning logs printed by FileSystemPreferences class
RUN mkdir -p ${USER_HOME}/.java/.systemPrefs && \
    mkdir -p ${USER_HOME}/.java/.userPrefs  && \
    chmod -R 755 ${USER_HOME}/.java && \
    chown -R ${USER}:${USER_GROUP} ${USER_HOME}/.java

# Install Alpine Linux package to run binaries linked against glibc
RUN apk --no-cache add ca-certificates wget; \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/glibc-2.27-r0.apk; \
    apk add glibc-2.27-r0.apk;

# copy jdk, wso2 product distribution to user's home directory and copy mysql connector jar to product distribution
COPY --chown=wso2carbon:wso2 ${FILES}/${WSO2_SERVER_DIST} ${WSO2_SERVER_HOME}
COPY --chown=wso2carbon:wso2 ${FILES}/mysql-connector-java-*-bin.jar ${WSO2_SERVER_HOME}/lib
COPY --chown=wso2carbon:wso2 ${FILES}/mysql-connector-java-*-bin.jar ${WSO2_SERVER_HOME}/wso2/analytics/lib/ 
# artifacts for Kubernetes membership scheme based clustering
COPY --chown=wso2carbon:wso2 ${FILES}/dnsjava-*.jar ${WSO2_SERVER_HOME}/lib
COPY --chown=wso2carbon:wso2 ${FILES}/kubernetes-membership-scheme-*.jar ${WSO2_SERVER_HOME}/dropins

# set environment variables
ENV WSO2_SERVER_HOME=${WSO2_SERVER_HOME} \
    JAVA_OPTS="-Djava.util.prefs.systemRoot=${USER_HOME}/.java -Djava.util.prefs.userRoot=${USER_HOME}/.java/.userPrefs"

# set the user and work directory
USER ${USER_ID}
WORKDIR ${USER_HOME}

# set environment variables
ENV WSO2_SERVER_HOME=${WSO2_SERVER_HOME} \
    WORKING_DIRECTORY=${USER_HOME}
