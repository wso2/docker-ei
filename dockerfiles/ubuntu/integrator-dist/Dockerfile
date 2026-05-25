FROM ubuntu:25.10

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl locales unzip wget \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION jdk-25.0.2+10

# install Temurin OpenJDK 25
RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='a9d73e711d967dc44896d4f430f73a68fd33590dabc29a7f2fb9f593425b854c'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_aarch64_linux_hotspot_25.0.2_10.tar.gz'; \
         ;; \
       ppc64el|powerpc:common64) \
         ESUM='b262b735b215173003766da36588d5f717dceada0286db41b439f93fb2ada468'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_ppc64le_linux_hotspot_25.0.2_10.tar.gz'; \
         ;; \
       s390x|s390:64-bit) \
         ESUM='15e5cbcadcf3d43623c31b825063cdc2817b9f1ba840b51dc6ef70e5d33c84e3'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_s390x_linux_hotspot_25.0.2_10.tar.gz'; \
         ;; \
       amd64|i386:x86-64) \
         ESUM='987387933b64b9833846dee373b640440d3e1fd48a04804ec01a6dbf718e8ab8'; \
         BINARY_URL='https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_x64_linux_hotspot_25.0.2_10.tar.gz'; \
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
