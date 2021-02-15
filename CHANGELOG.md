# Changelog
All notable changes to this project 6.4.x per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

[v6.4.0.2]: https://github.com/wso2/docker-ei/compare/v6.4.0.1...v6.4.0.2

## v6.4.0.3 - 2021-02-15

### Added
- Support for passing product distribution URL as an argument to the dockerfile. By default distribution is taken from WSO2 GitHub release
- The MySQL JDBC connector is taken from the maven central repository

### Changed
- Update AdoptOpenJDK version to adoptopenjdk:8u282-b08-jdk-hotspot-focal in all Ubuntu based images
- Update AdoptOpenJDK version to adoptopenjdk/openjdk8:jdk8u282-b08-alpine in all Alpine based images
- Update K8S Membership scheme version to 1.0.7
- Improve the Docker resources of Analytics profile (worker and dashboard) to use the optimized WSO2 Enterprise Integrator product profile packs to build the corresponding profile Docker images  

## v6.4.0.2 - 2019-01-11

### Added
- Support for passing arguments to the WSO2 server startup script.

### Changed
- Use AdoptOpenJDK 8 in Alpine, CentOS and Ubuntu based Docker images for WSO2 Enterprise Integrator
v6.4.x profiles
- Improve the Docker resources to use the optimized WSO2 Enterprise Integrator product profile
packs to build the corresponding profile Docker images

## v6.4.0.1 - 2018-10-08

### Added
- Per profile Docker resources of WSO2 Enterprise Integrator v6.4.x for Alpine, CentOS, Ubuntu
- Docker Compose resources for WSO2 Integration deployment patterns
