# ------------------------------------------------------------------------
#
# Copyright 2020 WSO2, Inc. (http://wso2.com)
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

# Temporary stage: copies libgcc_s.so.1 to a known path regardless of host arch
FROM ubuntu:22.04 AS libgcc-provider
RUN mkdir -p /libgcc && find /usr/lib -name 'libgcc_s.so.1' -exec cp {} /libgcc/libgcc_s.so.1 \;

# Final image: Alpine with real glibc compat (allows glibc-compiled netty-tcnative .so to load)
FROM frolvlad/alpine-glibc:alpine-3.22_glibc-2.42

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apk update && apk upgrade --no-cache && apk add --no-cache tzdata musl-locales musl-locales-lang netcat-openbsd bash unzip curl \
    && rm -rf /var/cache/apk/*

# netty-tcnative requires libgcc_s.so.1 for C++ exception unwinding.
# The provider stage normalizes the path so this single COPY works on any host arch.
RUN mkdir -p /usr/glibc-compat/lib
COPY --from=libgcc-provider /libgcc/libgcc_s.so.1 /usr/glibc-compat/lib/libgcc_s.so.1

ENV JAVA_VERSION=jdk-21.0.11+10

# Install glibc-compiled Temurin JRE (NOT the alpine-linux/musl variant)
RUN set -eux; \
    ARCH="$(uname -m)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         ESUM='e5038aae3ca9ff670bc696496b0728dbd23d280026bad30291cb919221ecfdcb'; \
         BINARY_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jre_x64_linux_hotspot_21.0.11_10.tar.gz'; \
         ;; \
       aarch64|arm64) \
         ESUM='fa23d9d9945053e67bcc7638410eabf1e17a7672c7c95a24f70cd08b8407d36e'; \
         BINARY_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.11%2B10/OpenJDK21U-jre_aarch64_linux_hotspot_21.0.11_10.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -fL -o /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM}  /tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    tar --extract \
        --file /tmp/openjdk.tar.gz \
        --directory /opt/java/openjdk \
        --strip-components 1 \
        --no-same-owner \
    ; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/usr/glibc-compat/bin:/opt/java/openjdk/bin:$PATH"

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>" \
      com.wso2.docker.source="https://github.com/wso2/docker-ei/releases/tag/v4.6.0.0"

ARG USER=wso2carbon
ARG USER_ID=10802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=10802
ARG USER_HOME=/home/${USER}
ARG WSO2_SERVER_NAME=wso2-integration-control-plane
ARG WSO2_SERVER_VERSION=2.0.0
ARG WSO2_SERVER_REPOSITORY=micro-integrator
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_SERVER_DIST_URL=<INTEGRATION_CONTROL_PLANE_DIST_URL>
# build argument for MOTD
ARG MOTD='printf "\n\
 Welcome to WSO2 Docker Resources \n\
 --------------------------------- \n\
 This Docker container comprises of a WSO2 product, running with its latest GA release \n\
 which is under the Apache License, Version 2.0. \n\
 Read more about Apache License, Version 2.0 here @ http://www.apache.org/licenses/LICENSE-2.0.\n"'
ENV ENV=${USER_HOME}"/.ashrc"

RUN \
    addgroup -S -g ${USER_GROUP_ID} ${USER_GROUP} \
    && adduser -S -u ${USER_ID} -h ${USER_HOME} -G ${USER_GROUP} ${USER} \
    && echo ${MOTD} > "${ENV}"

COPY --chown=wso2carbon:wso2 docker-entrypoint.sh ${USER_HOME}/

RUN \
    wget -O ${WSO2_SERVER}.zip "${WSO2_SERVER_DIST_URL}" \
    && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
    && rm -f ${WSO2_SERVER}.zip \
    && chown wso2carbon:wso2 -R ${WSO2_SERVER_HOME}

# Remove Alpine marker so icp.sh does not add -Dio.netty.handler.ssl.noOpenSsl=true.
# With glibc present the native tcnative library loads correctly and that flag must not be set.
RUN rm -f /etc/alpine-release

USER ${USER_ID}
WORKDIR ${USER_HOME}

ENV WORKING_DIRECTORY=${USER_HOME} \
    WSO2_SERVER_HOME=${WSO2_SERVER_HOME}

EXPOSE 9445 9446 9449

ENTRYPOINT ["/home/wso2carbon/docker-entrypoint.sh"]
