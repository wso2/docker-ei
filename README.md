# Docker Resources for WSO2 Enterprise Integrator

This repository contains following Docker resources :

- Per-profile Dockerfiles to create docker images
- Docker-compose files to evaluate most common deployment profiles

Per-profile dockerfiles enables us to build generic Docker images for deploying the product as profiles <br>
in containerized environments. Each includes the JDK, product distribution and a collection of utility libraries. <br>
Configurations, JDBC driver, extensions and other deployable artifacts are designed to be provided via volume mounts.

Docker Compose files have been created according to most common Enterprise Integrator deployment profiles <br>
for allowing users to evaluate product features to meet their co-operate integration requirements. The Docker Compose <br>
files make use of the per-profile docker images of WSO2 Enterprise Integrator and MySQL Docker image.