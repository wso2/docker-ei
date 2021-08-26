# Dockerfile for WSO2 Enterprise Integrator Analytics #

This section defines the step-by-step instructions to build [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker images for Analytics profile
in WSO2 Enterprise Integrator 6.2.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above

## How to build an image and run
##### 1. Checkout this repository into your local machine using the following Git command.

```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfile/ubuntu/analytics` directory will be referred to as `ANALYTICS_DOCKERFILE_HOME` from this point onwards.

##### 2. Build Docker images specific to each profile.

- Navigate to `<ANALYTICS_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-analytics:6.2.0 .`
- If you want to use your own distribution, you may build the image by executing the following command,
    + eg:- Hosted locally:` docker build --build-arg WSO2_SERVER_DIST_URL=http://172.17.0.1:8000/wso2ei-6.2.0.zip -t wso2ei-<PROFILE>:6.2.0 .`

##### 3. Running Docker images specific to each profile.

- `docker run -p 9444:9444 -p 9612:9612 ...all-port-mappings-here... wso2ei-analytics:6.2.0`

##### 4. Accessing the Dashboard portal.

- To access the management console, use the docker host IP and port 9446.
    + `https:<DOCKER_HOST>:9444/carbon`

>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## How to update configurations
Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `carbon.xml` is as follows.

##### 1. Stop the Broker profile container if it's already running.
In Broker profile product distribution, `carbon.xml` configuration file can be found at `<DISTRIBUTION_HOME>/wso2/analytics/conf`.
Copy the file to some suitable location of the host machine, referred to as `<SOURCE_CONFIGS>/carbon.xml` and
increase the offset value under ports by 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/carbon.xml`
```
chmod o+r <SOURCE_CONFIGS>/carbon.xml
```

##### 3. Run the image by mounting the file to container as follows.
```
docker run \
-p 9445:9445 \
--volume <SOURCE_CONFIGS>/carbon.xml:<TARGET_CONFIGS>/carbon.xml \
wso2ei-analytics:6.2.0
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-6.2.0/wso2/analytics/conf folder of the container.


## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)