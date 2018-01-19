# WSO2 Enterprise Integrator <br> For Integration and Broker Use-cases<br> with Analytics Support

![alt tag](deployment-diagram.png)

## Prerequisites

 * [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose) are required to run this deployment.

## How to Run

  1. Pull necessary images or build them using their [Dockerfiles](../../dockerfiles):
     ```
     docker pull wso2ei-integrator:6.1.1
     docker pull wso2ei-broker:6.1.1
     docker pull wso2ei-analytics:6.1.1
     ```

  2. Pull MySQL Docker image:
     ```
     docker pull mysql:5.7.19
     ```

  3. Download the latest Docker resources for the product from [releases](https://github.com/wso2/docker-ei/releases) <br>
     page or clone this repository to your home machine and switch to latest tag.

  4. Switch to docker-compose/integrator-broker-analytics folder:
     ```
     cd [docker-ei]/docker-compose/integrator-broker-analytics
     ```

  5. Download [MySQL Connector/J](https://downloads.mysql.com/archives/c-j/) v5.1.34 and copy its JAR file to following locations:
     ```
     [docker-ei]/docker-compose/integrator-broker-analytics/integrator/lib
     [docker-ei]/docker-compose/integrator-broker-analytics/broker/lib
     [docker-ei]/docker-compose/integrator-broker-analytics/analytics/lib
     ```

  6. Execute following Docker Compose command to start the deployment:
     ```
     docker-compose up
     ```

  7. Once the deployment process is complete add a host entry pointing to the Docker host machine IP address. <br>
     For an example if the Docker host is accessible via 127.0.0.1 on a Linux or Mac machine, add the <br>
     following entry in /etc/hosts file:

     ```
     127.0.0.1 wso2ei
     ```

  8. Access management console via a web browser:
     ```
     For Integrator - https://wso2ei:9443/carbon
     For Analytics - https://wso2ei:9444/carbon
     For Broker - https://wso2ei:9446/carbon
     ```
