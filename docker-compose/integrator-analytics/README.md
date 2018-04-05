# WSO2 Enterprise Integrator <br> For Integration Use-cases With Analytics Support

![alt tag](deployment-diagram.png)

## Prerequisites

 * Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://www.docker.com/get-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
   in order to run the steps provided in following Quick start guide. <br><br>
  * In order to run this Docker Compose setup, you will need an active [Free Trial Subscription](https://wso2.com/free-trial-subscription) 
   from WSO2 since the referring Docker images hosted at docker.wso2.com contains the latest updates and fixes for WSO2 Enterprise Integrator. You can sign up for a Free Trial Subscription [here](https://wso2.com/free-trial-subscription). <br><br>
 * If you wish to run the Docker Compose setup using Docker images built locally, build Integrator, Analytics Docker images using [Dockerfiles](../../dockerfiles/README.md) and remove the `docker.wso2.com/` prefix from the `image` name In the `docker-compose.yml`. <br> 
   For example, change the line `image: docker.wso2.com/wso2ei-analytics:6.2.0` to <br> `image: wso2ei-analytics:6.2.0`. <br><br>
       
## How to Run


  1. Clone WSO2 Enterprise Integrator Docker git repository.
     ```
     git clone https://github.com/wso2/docker-ei
     ```
     > If you are to try out an already released zip of this repo, please ignore this 1st step. 

  2. Switch to the `docker-compose/integrator-analytics` folder.
     ```
     cd docker-ei/docker-compose/integrator-analytics
     ```
     > If you are to try out an already released zip of this repo, please ignore this 2nd step also. 
     Instead, extract the zip file and directly browse to `docker-ei-<released-version>/docker-compose/integrator-analytics` folder. 
     
     > If you are to try out an already released tag, after executing 2nd step, checkout the relevant tag, 
     i.e. for example: <br> git checkout tags/v6.2.0.1 and continue below steps.

  3. Execute following Docker Compose command to start the deployment.
     ```
     docker-compose up
     ```
       
  4. Access management console via a web browser.
     ```
     For Integrator - https://localhost:9443/carbon
     For Analytics - https://localhost:9444/portal
     ```
