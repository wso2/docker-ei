# Changelog
All notable changes to this project `7.0.x` per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v7.0.0.6] - 2024-01-23

### Changed
- Update Ubuntu Dockerfiles to get continuous upgrades.

## [v7.0.0.5] - 2022-03-04

### Changed
- Use base OS images as opposed to AdoptOpenJDK images for each corresponding OS flavour (Alpine, CentOS, Ubuntu).
- Use Temurin OpenJDK binaries to build OpenJDK on top of the base OS image.
- Upgrade OpenJDK versions to the latest available versions of Temurin OpenJDK from Adoptium.

## [v7.0.0.4] - 2020-11-24

### Added
- Add git release tag as a label (refer to [issue](https://github.com/wso2/docker-ei/issues/212))

### Changed
- Enable SSL verification when retrieving remote resources using wget (refer to [issue](https://github.com/wso2/docker-ei/issues/213))
- Upgrade base Docker images to jdk-11.0.9_11

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v7.0.0.4](https://github.com/wso2/docker-ei/milestone/16).

## [v7.0.0.3] - 2020-07-03

### Changed
- Upgrade AdoptOpenJDK 8 version to the version - 11.0.7_10-jdk

### Removed
- Removed Checksum for AdoptOpenJDK in centos based Dockerfile

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v7.0.0.3](https://github.com/wso2/docker-ei/milestone/11).

## [v7.0.0.2] - 2020-01-21

### Fixed
- Fix MySQL connector jar download URL

## [v7.0.0.1] - 2019-11-19

### Added
- Per profile Docker resources of WSO2 Integration v7.0.x product profiles (Micro Integrator and Streaming Integrator)
for Alpine, CentOS and Ubuntu

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v7.0.0.1](https://github.com/wso2/docker-ei/milestone/8).

[v7.0.0.1]: https://github.com/wso2/docker-ei/compare/v6.5.0.3...v7.0.0.1
[v7.0.0.2]: https://github.com/wso2/docker-ei/compare/v7.0.0.1..v7.0.0.2
[v7.0.0.3]: https://github.com/wso2/docker-ei/compare/v7.0.0.2..v7.0.0.3
[v7.0.0.4]: https://github.com/wso2/docker-ei/compare/v7.0.0.3..v7.0.0.4
