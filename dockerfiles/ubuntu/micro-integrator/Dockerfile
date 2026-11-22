# ------------------------------------------------------------------------
#
# Copyright 2019 WSO2, Inc. (http://wso2.com)
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

# set base Docker image to Ubuntu Docker image
FROM ubuntu:26.04

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install dependencies
RUN apt-get update && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales python-is-python3 netcat-openbsd unzip wget \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION=jdk-25.0.5.1+2

# install Temurin OpenJDK 25
RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       arm64|aarch64) \
         ESUM='c37879e0d08eeb1baa69fcbb7758cd455b7b1c0ceab1e2a136ccb1713c530984'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.5.1%2B2/OpenJDK25U-jdk_aarch64_linux_hotspot_25.0.5.1_2.tar.gz'; \
         ;; \
       ppc64el|powerpc:common64) \
         ESUM='cfffd074eb1fb7a7b38cae9341363c1c35094a5b5f7d49c08b406159dae65872'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.5.1%2B2/OpenJDK25U-jdk_ppc64le_linux_hotspot_25.0.5.1_2.tar.gz'; \
         ;; \
       s390x|s390:64-bit) \
         ESUM='01da4a2bbc08b3d7afb44de5bb83e2fbd838e06b83aabf3ca0204f916438e339'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.5.1%2B2/OpenJDK25U-jdk_s390x_linux_hotspot_25.0.5.1_2.tar.gz'; \
         ;; \
       amd64|i386:x86-64) \
         ESUM='760f91b22c3efc9bd1b64ff950598231be82928cc807e30691a0e7a2995a62c0'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.5.1%2B2/OpenJDK25U-jdk_x64_linux_hotspot_25.0.5.1_2.tar.gz'; \
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

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-ei/releases/tag/v4.7.0.4"

# set Docker image build arguments
# build arguments for user/group configurations
ARG USER=wso2carbon
ARG USER_ID=10802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=10802
ARG USER_HOME=/home/${USER}
# build arguments for WSO2 product installation
ARG WSO2_SERVER_NAME=wso2mi
ARG WSO2_SERVER_VERSION=4.7.0
ARG WSO2_SERVER_REPOSITORY=micro-integrator
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_SERVER_DIST_URL=<MI_DIST_URL>
# build argument for MOTD
ARG MOTD="\n\
Welcome to WSO2 Docker resources.\n\
------------------------------------ \n\
This Docker container comprises of a WSO2 product, running with its latest GA release \n\
which is under the Apache License, Version 2.0. \n\
Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"

# create the non-root user and group and set MOTD login message
RUN \
    groupadd --system -g ${USER_GROUP_ID} ${USER_GROUP} \
    && useradd --system --create-home --home-dir ${USER_HOME} --no-log-init -g ${USER_GROUP_ID} -u ${USER_ID} ${USER} \
    && echo '[ ! -z "${TERM}" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc; echo "${MOTD}" > /etc/motd

# copy init script to user home
COPY --chown=wso2carbon:wso2 docker-entrypoint.sh ${USER_HOME}/

# add the WSO2 product distribution to user's home directory
RUN \
    wget -O ${WSO2_SERVER}.zip "${WSO2_SERVER_DIST_URL}" \
    && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
    && rm -f ${WSO2_SERVER}.zip \
    && chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}

# remove unnecesary packages
RUN apt-get purge -y unzip wget

# set the user and work directory
USER ${USER_ID}
WORKDIR ${USER_HOME}

# set environment variables
ENV WORKING_DIRECTORY=${USER_HOME} \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

# expose server ports
EXPOSE 8290 8253

# initiate container and start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
