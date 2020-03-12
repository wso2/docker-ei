# WSO2 Enterprise Integrator <br> For Integration Use-cases With Analytics Support

![alt tag](deployment-diagram.png)

## Prerequisites

 * Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
   in order to run the steps provided in following Quick start guide. <br><br>
 * In order to use Docker images with WSO2 updates, you need an active WSO2 subscription.
   Otherwise, you can proceed with Docker images available at [DockerHub](https://hub.docker.com/u/wso2/), which are created using GA releases.<br><br>
 * If you wish to run the Docker Compose setup using Docker images built locally, build Docker images using Docker resources available from [here](../../dockerfiles/) and
   remove the `docker.wso2.com/` prefix from the `image` name in the `docker-compose.yml`. <br><br>

## Quick Start Guide

1. Login to WSO2's Private Docker Registry via Docker client. When prompted, enter the username and password of your WSO2 Subscription.

   ```
   docker login docker.wso2.com
   ```

2. Clone WSO2 API Management Docker and Docker Compose resource Git repository.

   ```
   git clone https://github.com/wso2/docker-ei
   ```
   
   > If you are to try out an already released zip of this repo, please ignore this 2nd step. 

3. Switch to `docker-compose/integrator-analytics` folder.

   ```
   cd docker-ei/docker-compose/integrator-analytics
   ```
   
   > If you intend to try out an already released zip of this repository, extract the zip file and directly browse to
   `docker-ei-<released-version-here>/docker-compose/integrator-analytics` folder. 
     
   > If you intend to try out an already released tag, after executing 2nd step, checkout the relevant tag, 
    i.e. for example: `git checkout tags/v6.6.0.1`, switch to `docker-compose/integrator-analytics` folder and continue with below steps.

4. Execute following Docker Compose command to start the deployment.

   ```
   docker-compose up
   ```

5. Access the WSO2 Enterprise Integrator web UIs using the below URLs via a web browser.

     ```
     For Integrator - https://localhost:9443/carbon
     For Analytics - https://localhost:9643/portal
     ```
   
   Login to the web UIs using following credentials.
   
   * Username: admin <br>
   * Password: admin
