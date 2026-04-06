FROM rockylinux:9.5

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN dnf update -y \
    && dnf install -y ca-certificates curl glibc-langpack-en unzip wget \
    && dnf clean all

ENV JAVA_VERSION jdk-21.0.6+7

# install Temurin OpenJDK 21
RUN set -eux; \
    ARCH="$(objdump="$(command -v objdump)" && objdump --file-headers "$objdump" | awk -F '[:,]+[[:space:]]+' '$1 == "architecture" { print $2 }')"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='04fe1273f624187d927f1b466e8cdb630d70786db07bee7599bfa5153060afd3'; \
         BINARY_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.6_7.tar.gz'; \
         ;; \
       ppc64el|powerpc:common64) \
         ESUM='163724b70b86d5a8461f85092165a9cc5a098ed900fee90d1b0c0be9607ae3d2'; \
         BINARY_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.6_7.tar.gz'; \
         ;; \
       amd64|i386:x86-64) \
         ESUM='a2650fba422283fbed20d936ce5d2a52906a5414ec17b2f7676dddb87201dbae'; \
         BINARY_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.6_7.tar.gz'; \
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

LABEL maintainer="WSO2 Docker Maintainers <dev@wso2.org>"

ARG USER=wso2carbon
ARG USER_ID=10802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=10802
ARG USER_HOME=/home/${USER}
ARG WSO2_SERVER_NAME=wso2-integrator-dist
ARG WSO2_SERVER_VERSION=5.0.0
ARG WSO2_SERVER=${WSO2_SERVER_NAME}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER}
ARG WSO2_SERVER_DIST_URL=<INTEGRATOR_DIST_URL>

RUN groupadd --system -g ${USER_GROUP_ID} ${USER_GROUP} \
    && useradd --system --create-home --home-dir ${USER_HOME} --no-log-init -g ${USER_GROUP_ID} -u ${USER_ID} ${USER}

RUN wget -O ${WSO2_SERVER}.zip "${WSO2_SERVER_DIST_URL}" \
    && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
    && rm -f ${WSO2_SERVER}.zip \
    && chown -R ${USER}:${USER_GROUP} ${USER_HOME}

ENV BALLERINA_HOME=${WSO2_SERVER_HOME}/ballerina-2201.13.2
ENV PATH="${BALLERINA_HOME}/bin:${PATH}"

USER ${USER_ID}
WORKDIR ${USER_HOME}

CMD ["bal", "version"]
