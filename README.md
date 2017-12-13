# WSO2 Enterprise Integrator Docker Resources

This repository contains following Docker resources:

- Per-profile Dockerfiles
- Per-pattern Docker Compose Templates

Per-profile dockerfiles enables us to build generic Docker images for deploying the product as profiles <br>
in containerized environments. Each includes the JDK, product distribution and a collection of utility libraries. <br>
Configurations, JDBC driver, extensions and other deployable artifacts are designed to be provided via volume mounts.

The Docker Compose templates have been created according to standard Enterprise Integrator deployment patterns <br>
for allowing users to evaluate the product and understand the deployment architecture in depth. The Docker Compose <br>
templates make use of the per-profile images, MySQL Docker image and HAProxy Docker image.