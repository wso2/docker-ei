# Changelog
All notable changes to this project 6.5.x per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

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

[v6.5.0.2]: https://github.com/wso2/docker-ei/compare/v6.5.0.1...v6.5.0.2
