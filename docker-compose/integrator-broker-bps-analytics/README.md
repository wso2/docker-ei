# WSO2 Enterprise Integrator <br> For Integration, Broker and Business Process (BPS) <br> Use-cases With Analytics Support

![alt tag](deployment-diagram.png)

## Prerequisites

  * [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose) are required to run this deployment.

## How to Run

  1. Pull necessary images or build them using their [Dockerfiles](../../dockerfiles) :
     ```
     docker pull wso2ei-integrator:6.1.1
     docker pull wso2ei-broker:6.1.1
     docker pull wso2ei-business-process:6.1.1
     docker pull wso2ei-analytics:6.1.1
     ```

  2. Pull MySQL Docker image :
     ```
     docker pull mysql:5.7.20
     ```

  3. Download the latest Docker resources for the product from [releases](https://github.com/wso2/docker-ei/releases) 
     page or clone this repository <br> to your local machine and switch to latest release tag.
     
     > Note that the local copy of `docker-ei` repository will be referred to as `[docker-ei]` from this point onwards.

  4. Switch to docker-compose/integrator-broker-bps-analytics folder :
     ```
     cd [docker-ei]/docker-compose/integrator-broker-bps-analytics
     ```

  5. Download [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) v5.1.45 to your local machine and copy to following locations :
     ```
     [docker-ei]/docker-compose/integrator-broker-bps-analytics/integrator/lib
     [docker-ei]/docker-compose/integrator-broker-bps-analytics/broker/lib
     [docker-ei]/docker-compose/integrator-broker-bps-analytics/business-process/lib
     [docker-ei]/docker-compose/integrator-broker-bps-analytics/analytics/lib
     ```
     
     > Note that SSL is by default set to false for all MySQL datasource configurations as latest connectors restrict SSL communication only for MySQL servers with verified server certificates.
     
  6. Download [Andes Client](http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/andes/wso2/andes-client/3.2.19/) JAR v3.2.19,
     [Geronimo JMS Spec](http://maven.wso2.org/nexus/content/groups/wso2-public/org/apache/geronimo/specs/wso2/geronimo-jms_1.1_spec/1.1.0.wso2v1/) JAR v1.1.0.wso2v1
     to your local machine <br> and copy them to following location :
     ```
     [docker-ei]/docker-compose/integrator-broker-bps-analytics/integrator/lib
     ```

  7. Before to start deployment process, add a host entry pointing to the Docker host machine IP address. <br>
     For an example if the Docker host is accessible via 127.0.0.1 on a Linux or Mac machine, add <br>
     following entry to /etc/hosts file :
     ```
     127.0.0.1 wso2ei-integrator wso2ei-analytics wso2ei-broker wso2ei-business-process
     ```
          
  8. Execute following Docker Compose command to start the deployment :
     ```
     docker-compose up
     ```
     
  9. Access management console via a web browser :
     ```
     For Integrator - https://wso2ei-integrator:9443/carbon
     For Analytics - https://wso2ei-analytics:9444/carbon
     For Business Process - https://wso2ei-business-process:9445/carbon
     For Broker - https://wso2ei-broker:9446/carbon
     ```
