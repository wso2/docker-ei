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
FROM ubuntu:20.04

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-ei/releases/tag/v6.3.0.2"

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
ARG WSO2_SERVER_VERSION=6.3.0
ARG WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER_PACK}
ARG WSO2_SERVER_DIST_URL=https://github.com/wso2/product-ei/releases/download/v${WSO2_SERVER_VERSION}/${WSO2_SERVER_PACK}.zip

ARG MYSQL_CONNECTOR_VERSION=5.1.47
ARG DNS_JAVA_JAR_VERSION=2.1.8
ARG KUBERNETES_MEMBER_SCHEME_VERSION=1.0.5
# set WSO2 EULA
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of a WSO2 product, running with its latest GA release \n\
which is under the Apache License, Version 2.0. \n\
Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV JAVA_VERSION jdk8u322-b06

# install required packages
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales netcat python-is-python3 unzip wget \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/* \
    echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' \
    >> /etc/bash.bashrc \
    ; echo "$MOTD" > /etc/motd

# create a user group and a user
RUN groupadd --system -g ${USER_GROUP_ID} ${USER_GROUP} && \
    useradd --system --create-home --home-dir ${USER_HOME} --no-log-init -g ${USER_GROUP_ID} -u ${USER_ID} ${USER}

# installe Oracle JDK
RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='42ed3ff5a859f9015a1362fb7e650026b913d688eab471714f795651120be173'; \
         BINARY_URL='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_aarch64_linux_hotspot_8u322b06.tar.gz'; \
         ;; \
       ppc64el|powerpc:common64) \
         ESUM='c7cc9c5b237e9e1f1e3296593aba427375823592e4604fadf89a8c234c2574e1'; \
         BINARY_URL='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_ppc64le_linux_hotspot_8u322b06.tar.gz'; \
         ;; \
       amd64|i386:x86-64) \
         ESUM='3d62362a78c9412766471b05253507a4cfc212daea5cdf122860173ce902400e'; \
         BINARY_URL='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_x64_linux_hotspot_8u322b06.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

RUN chown wso2carbon:wso2 -R ${JAVA_HOME}

# Verify Java installation
RUN echo Verifying install ... \
    && echo javac -version && javac -version \
    && echo java -version && java -version \
    && echo Complete.

# add the WSO2 product distribution to user's home directory
RUN \
    wget -O ${WSO2_SERVER}.zip "${WSO2_SERVER_DIST_URL}" \
    && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
    && chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME} \
    && mkdir -p ${WORKING_DIRECTORY}/wso2-tmp \
    && cp -r ${WSO2_SERVER_HOME}/repository/deployment/server/ ${WORKING_DIRECTORY}/wso2-tmp
# copy entrypoint bash script to user home
COPY --chown=wso2carbon:wso2 init.sh ${USER_HOME}/
# copy relevant libraries (mysql connector jar and integrator libraries) to product distribution
# add MySQL JDBC connector to server home as a third party library
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${WSO2_SERVER_HOME}/dropins/
ADD --chown=wso2carbon:wso2 http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/andes/wso2/andes-client/3.2.64/andes-client-3.2.64.jar ${WSO2_SERVER_HOME}/lib/
ADD --chown=wso2carbon:wso2 http://maven.wso2.org/nexus/content/groups/wso2-public/org/apache/geronimo/specs/wso2/geronimo-jms_1.1_spec/1.1.0.wso2v1/geronimo-jms_1.1_spec-1.1.0.wso2v1.jar ${WSO2_SERVER_HOME}/lib/
ADD --chown=wso2carbon:wso2 http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/securevault/org.wso2.securevault/1.0.0-wso2v2/org.wso2.securevault-1.0.0-wso2v2-sources.jar ${WSO2_SERVER_HOME}/lib/
# add libraries for Kubernetes membership scheme based clustering
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/dnsjava/dnsjava/${DNS_JAVA_JAR_VERSION}/dnsjava-${DNS_JAVA_JAR_VERSION}.jar ${WSO2_SERVER_HOME}/lib
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/org/wso2/carbon/kubernetes/artifacts/kubernetes-membership-scheme/${KUBERNETES_MEMBER_SCHEME_VERSION}/kubernetes-membership-scheme-${KUBERNETES_MEMBER_SCHEME_VERSION}.jar ${WSO2_SERVER_HOME}/dropins

# set the user and work directory
USER ${USER_ID}
WORKDIR ${USER_HOME}

# set environment variables
ENV WSO2_SERVER_HOME=${WSO2_SERVER_HOME} \
    WORKING_DIRECTORY=${USER_HOME}

# expose integrator ports
EXPOSE 8280 8243 9443 4100

# set entrypoint to init script
ENTRYPOINT ["/home/wso2carbon/init.sh"]
