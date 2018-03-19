# WSO2 Enterprise Integrator <br> For Integration Use-cases With Analytics Support

![alt tag](deployment-diagram.png)

## Prerequisites

  * [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose) are required to run this deployment.

## How to Run

  1. Build Integrator and Analytics Images using [Dockerfiles](../../README.md) 
     > In order to run the Docker Compose configuration, you will need an active subscription from WSO2 since the 
     Docker images hosted at docker.wso2.com contains the latest updates and fixes to WSO2 Enterprise Integrator. 
     You can sign up for a Free Trial Subscription [here](https://wso2.com/free-trial-subscription)

     > If you wish to run the Docker Compose configuration using Docker images built locally, remove the `docker.wso2
     .com/` prefix from the `image` name In the `docker-compose.yml`
       
     > For example, change the line `image: docker.wso2.com/wso2ei-analytics:6.1.1` to `image: wso2ei-analytics:6.1.1`
    
  2. Pull MySQL Docker image :
     ```
     docker pull mysql:5.7.20
     ```

  3. Download the latest Docker resources for the product from [releases](https://github.com/wso2/docker-ei/releases) 
     page or clone this repository <br> to your local machine and switch to latest release tag.
     
     > Note that the local copy of `docker-ei` repository will be referred to as `[docker-ei]` from this point onwards.

     
  4. Before to start deployment process, add a host entry pointing to the Docker host machine IP address. <br>
     For an example if the Docker host is accessible via 127.0.0.1 on a Linux or Mac machine, add <br>
     following entry to /etc/hosts file :
     ```
     127.0.0.1 wso2ei-integrator wso2ei-analytics
     ```

  5. Execute following Docker Compose command to start the deployment :
     ```
     docker-compose up
     ```
       
  6. Access management console via a web browser :
     ```
     For Integrator - https://wso2ei-integrator:9443/carbon
     For Analytics - https://wso2ei-analytics:9444/carbon
     ```
