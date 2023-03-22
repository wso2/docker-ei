# Docker Resources for WSO2 Integration

This repository contains following Docker resources:

- Per profile Docker resources of WSO2 Integration v4.2.x product profiles (Micro Integrator, Streaming Integrator and MI Dashboard)
  for Alpine, CentOS and Ubuntu

Per profile Docker resources for WSO2 Integration help you build generic Docker images for deploying the
corresponding product servers in containerized environments.

Each Docker image includes the Java Development Kit, the relevant product distribution and a collection of utility libraries.
Configurations and non-configuration resources (e.g. binaries such as, third-party libraries, Carbon extensions,
Carbon Applications and security related artifacts such as, Java Keystore files) are designed to be provided via
volume mounts to the containers spawned.

**Change log** from previous v4.1.x release: [View Here](https://github.com/wso2/docker-ei/blob/4.1.x/CHANGELOG.md)
