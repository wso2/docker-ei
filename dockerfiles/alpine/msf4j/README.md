# Dockerfile for MSF4J profile of WSO2 Enterprise Integrator #
This section defines the step-by-step instructions to build an [Alpine](https://hub.docker.com/_/alpine/) Linux based Docker image
MSF4J profile for WSO2 Enterprise Integrator 6.4.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above


## How to build an image and run
##### 1. Checkout this repository into your local machine using the following Git command.
```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfiles/alpine/msf4j` directory will be referred to as `MSF4J_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.
- Navigate to `<MSF4J_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-msf4j:6.4.0-alpine .`
- If you want to use your own distribution, you may build the image by executing the following command,
    + eg:- Hosted locally:` docker build --build-arg WSO2_SERVER_DIST_URL=http://172.17.0.1:8000/wso2ei-6.4.0.zip -t wso2ei-msf4j:6.4.0-alpine .`
    
##### 4. Running the Docker image.
- `docker run -p 9090:9090 wso2ei-msf4j:6.4.0-alpine`
    
>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.


## How to update configurations
Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `carbon.xml` is as follows.

##### 1. Stop the Micro Integrator profile container if it's already running.
In MSF4J profile product distribution, `carbon.yml` configuration file can be found at `<DISTRIBUTION_HOME>/wso2/msf4j/conf`.
Copy the file to some suitable location of the host machine, referred to as `<SOURCE_CONFIGS>/carbon.yml` and increase
the offset value under ports by 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/carbon.yml`
```
chmod o+r <SOURCE_CONFIGS>/carbon.yml
```

##### 3. Run the image by mounting the file to container as follows.
```
docker run \
-p 9091:9091 \
--volume <SOURCE_CONFIGS>/carbon.yml:<TARGET_CONFIGS>/carbon.yml \
wso2ei-msf4j:6.4.0-alpine
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-6.4.0/wso2/msf4j/conf folder of the container.


## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
