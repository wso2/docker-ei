FROM alpine:3.22.2

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apk update && apk upgrade --no-cache \
    && apk add --no-cache ca-certificates curl musl-locales musl-locales-lang unzip wget \
    && rm -rf /var/cache/apk/*

ENV JAVA_VERSION jdk-21.0.6+7

# install Temurin OpenJDK 21
RUN set -eux; \
    ARCH="$(apk --print-arch)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         ESUM='6c66470a9143ad562570a34c1583d9fa50bf904f6f9ced642e9d800ce043a0f3'; \
         BINARY_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_x64_alpine-linux_hotspot_21.0.6_7.tar.gz'; \
         ;; \
       aarch64|arm64) \
         ESUM='2798990401d9c47eaeddb7d5148f577770e4c1013b9223290a43765463204ae4'; \
         BINARY_URL='https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.6%2B7/OpenJDK21U-jdk_aarch64_alpine-linux_hotspot_21.0.6_7.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    wget -O /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    tar --extract \
        --file /tmp/openjdk.tar.gz \
        --directory /opt/java/openjdk \
        --strip-components 1 \
        --no-same-owner \
    ; \
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

RUN addgroup -S -g ${USER_GROUP_ID} ${USER_GROUP} \
    && adduser -S -u ${USER_ID} -h ${USER_HOME} -G ${USER_GROUP} ${USER}

RUN wget -O ${WSO2_SERVER}.zip "${WSO2_SERVER_DIST_URL}" \
    && unzip -d ${USER_HOME} ${WSO2_SERVER}.zip \
    && rm -f ${WSO2_SERVER}.zip \
    && chown -R ${USER}:${USER_GROUP} ${USER_HOME}

ENV BALLERINA_HOME=${WSO2_SERVER_HOME}/ballerina-2201.13.2
ENV PATH="${BALLERINA_HOME}/bin:${PATH}"

USER ${USER_ID}
WORKDIR ${USER_HOME}

CMD ["bal", "version"]
