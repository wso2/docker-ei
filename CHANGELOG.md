# Changelog

All notable changes to this project `4.4.x` per each release will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [v4.4.1.0] - 2026-10-13
### Changed
- Updated streaming-integrator Dockerfiles for WSO2 Integrator: SI 4.4.1, moving to Alpine 3.24.2, Rocky Linux 9.8, Ubuntu 26.04 and Temurin OpenJDK 25.0.4.1+1.
### Fixed
- Added bash to the Alpine streaming-integrator image so that `bin/extension-installer.sh` can run.
- Exposed the Siddhi Store Query API ports 7070 and 7443 in the streaming-integrator images.
- Installed glibc-langpack-en in the Rocky streaming-integrator image so the configured en_US.UTF-8 locale is available.

## [v4.4.0.0] - 2026-05-18
### Added
- Added Dockerfiles for WSO2 Integrator: SI 4.4.0 on Alpine, Rocky Linux 9.5, and Ubuntu 24.04, bundling Temurin OpenJDK 25.0.2+10.

## [v4.2.0.8] - 2025-02-20
### Changed
- Updated OS and JDK versions in micro-integrator Dockerfiles for Alpine, Rocky and Ubuntu for MI 4.4.0 release.

## [v4.2.0.7] - 2024-07-19
### Changed
- Added Rocky Linux images for MI 4.2.0

## [v4.2.0.6] - 2024-01-23
### Changed
- Update Ubuntu Dockerfiles of MI dashboard and SI to get continuous upgrades.

## [v4.2.0.4] - 2024-01-02
### Changed
- Update Ubuntu Dockerfile to get continuous upgrades.

## [v4.2.0.1] - 2023-03-21
### Changed
- Add resources for micro-integrator, mi-dashboard and streaming integrator.
