# WSO2 Enterprise Integrator Analytics

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

2. Clone WSO2 Enterprise Integrator Docker and Docker Compose resource Git repository.

   ```
   git clone https://github.com/wso2/docker-ei
   ```
   
   > If you are to try out an already released zip of this repo, please ignore this 2nd step. 

3. Switch to `docker-compose/ei-analytics` folder.

   ```
   cd docker-ei/docker-compose/ei-analytics
   ```
   
   > If you intend to try out an already released zip of this repository, extract the zip file and directly browse to
   `docker-ei-<released-version-here>/docker-compose/ei-analytics` folder. 
     
   > If you intend to try out an already released tag, after executing 2nd step, checkout the relevant tag, 
    i.e. for example: `git checkout tags/v7.1.0`, switch to `docker-compose/ei-analytics` folder and continue with below steps.

4. Execute following Docker Compose command to start the deployment.

   ```
   docker-compose up
   ```

5. Access the WSO2 EI Analytics dashboard UI using the below URL via a web browser.

     ```
     https://localhost:9645/analytics-dashboard
     ```
   
   Login to the web UI using following credentials.
   
   * Username: admin <br>
   * Password: admin
