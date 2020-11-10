# Changelog
All notable changes to this project 6.5.x per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v6.5.0.5] - 2020-11-10

### Added
- Add git release tag as a label (refer to [issue](https://github.com/wso2/docker-ei/issues/216))

### Changed
- Enable SSL verification when retrieving remote resources using wget (refer to [issue](https://github.com/wso2/docker-ei/issues/220))

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v6.5.0.5](https://github.com/wso2/docker-ei/milestone/10)

## [v6.5.0.4] - 2020-01-21

### Fixed
- Fix MySQL connector jar download URL

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v6.5.0.4](https://github.com/wso2/docker-ei/milestone/6)

## [v6.5.0.3] - 2018-08-28

### Added
- Package the Kubernetes Membership Scheme in Docker images for Integrator profile of WSO2 Enterprise Integrator.

### Changed
- Use WSO2 product pack downloadable links to binaries available at JFrog Bintray.

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v6.5.0.3](https://github.com/wso2/docker-ei/milestone/5).

## [v6.5.0.2] - 2018-06-26

### Added
- Add downloadable links for obtaining dependencies required to be available in Docker image build context
- Use Dockerfile LABEL construct for defining the maintainer

### Changed
- Fix incorrect MOTDs
- Remove temporarily persisted, default content of persistent runtime artifact folders
- Prevent prepackaging additional artifacts required for Kubernetes Membership Scheme
- Avoid creating Java Prefs directories in WSO2 Integration v6.5.x Docker resources
- Fix issue with container startup failure when Docker image indirect mount points are empty

For detailed information on the tasks carried out during this release, please see the GitHub milestone
[v6.5.0.2](https://github.com/wso2/docker-ei/milestone/4).

## [v6.5.0.1] - 2018-05-24

### Added
- Per profile Docker resources of WSO2 Enterprise Integrator v6.5.x for Alpine, CentOS and Ubuntu
- Docker Compose resources for WSO2 Integration deployment patterns
- Remove the need to prepackage additional libraries required for communication between Integrator and Message Broker
- Integrate support in Docker Compose resources for users with and without WSO2 subscriptions

### Changed
- Use AdoptOpenJDK version `jdk8u212-b03` in Alpine, CentOS, Ubuntu based Docker resources

[v6.5.0.3]: https://github.com/wso2/docker-ei/compare/v6.5.0.2...v6.5.0.3
[v6.5.0.4]: https://github.com/wso2/docker-ei/compare/v6.5.0.3...v6.5.0.4
[v6.5.0.5]: https://github.com/wso2/docker-ei/compare/v6.5.0.4...v6.5.0.5
