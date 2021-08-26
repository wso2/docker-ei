# Changelog

All notable changes to this project `6.2.x` per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v6.2.0.9] - 2021-08-26

### Added
- Add per profile Docker resources of WSO2 Enterprise Integrator v6.2.x for Alpine, CentOS, Ubuntu

### Changed
- Update AdoptOpenJDK version to adoptopenjdk/openjdk8:jdk8u292-b10-alpine in all Alpine based images
- Update AdoptOpenJDK version to adoptopenjdk:8u292-b10-jdk-hotspot-focal in all Ubuntu based images
- Update AdoptOpenJDK version to jdk8u292-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u292b10 in all Centos based images
- Update K8s Membership scheme version to 1.0.7

## [v6.2.0.8] - 2020-11-25

### Added
- Add git release tag as a label (refer to [issue](https://github.com/wso2/docker-ei/issues/218))
- Add ca-certificates (refer to [issue](https://github.com/wso2/docker-ei/issues/244))
- Create wso2 user and group (refer to [issue](https://github.com/wso2/docker-ei/issues/245))
- Add GA product pack download URL

### Changed
- Enable SSL verification when retrieving remote resources using wget (refer to [issue](https://github.com/wso2/docker-ei/issues/222))

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v6.2.0.8](https://github.com/wso2/docker-ei/milestone/20).

[v6.2.0.8]: https://github.com/wso2/docker-ei/compare/v6.2.0.7...6.2.0.8
