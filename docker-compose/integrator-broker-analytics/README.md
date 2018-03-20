# WSO2 Enterprise Integrator <br> For Integration and Broker Use-cases <br> With Analytics Support

![alt tag](deployment-diagram.png)

## Prerequisites

  * [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose) are required for running this Docker Compose template.
  * In order to run this Docker Compose setup, you will need an active [Free Trial Subscription](https://wso2.com/free-trial-subscription) 
   from WSO2 since the referring Docker images hosted at docker.wso2.com contains the latest updates and fixes for WSO2 Enterprise Integrator. You can sign up for a Free Trial Subscription [here](https://wso2.com/free-trial-subscription). 
  * If you wish to run the Docker Compose setup using Docker images built locally, build Integrator, Broker, Analytics Docker images using [Dockerfiles](../../dockerfiles/README.md) and 
   remove the `docker.wso2.com/` prefix from the `image` name In the `docker-compose.yml`. For example, change the line `image: docker.wso2.com/wso2ei-analytics:6.1.1` to `image: wso2ei-analytics:6.1.1` 
   
## How to Run

  1. Clone WSO2 Enterprise Integrator Docker git repository.
     ```
     git clone https://github.com/wso2/docker-ei
     ```
     > Note that the local copy of `docker-ei` repository will be referred to as `[docker-ei]` from this point onwards.

  2. Switch to docker-compose/integrator-broker-analytics folder :
     ```
     cd [docker-ei]/docker-compose/integrator-broker-analytics
     ```

  3. Execute following Docker Compose command to start the deployment :
     ```
     docker-compose up
     ```

  4. Access management console via a web browser :
     ```
     For Integrator - https://localhost:9443/carbon
     For Analytics - https://localhost:9444/carbon
     For Broker - https://localhost:9446/carbon
     ```
