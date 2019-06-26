# Dockerfile for Integrator profile of WSO2 Enterprise Integrator #

This section defines the step-by-step instructions to build an [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker image
Integrator profile for WSO2 Enterprise Integrator 6.5.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfiles/ubuntu/integrator` directory will be referred to as `INTEGRATOR_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<INTEGRATOR_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-integrator:6.5.0 .`

> By default, the Docker image will prepackage the General Availability (GA) release version of the relevant WSO2 product.

##### 3. Running the Docker image.

- `docker run -p 8280:8280 -p 8243:8243 -p 9443:9443 wso2ei-integrator:6.5.0`

##### 4. Accessing management console.

- To access the management console, use the docker host IP and port 9443.
    + `https:<DOCKER_HOST>:9443/carbon`
    
>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `carbon.xml` is as follows:

##### 1. Stop the Integrator profile container if it's already running.

In Integrator profile product distribution, `carbon.xml` configuration file can be found at `<DISTRIBUTION_HOME>/conf`.
Copy the file to some suitable location of the host machine, referred to as `<SOURCE_CONFIGS>/carbon.xml` and
increase the offset value under ports by 1

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/carbon.xml`.

```
chmod o+r <SOURCE_CONFIGS>/carbon.xml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run \
-p 9444:9444 \
--volume <SOURCE_CONFIGS>/carbon.xml:<TARGET_CONFIGS>/carbon.xml \
wso2ei-integrator:6.5.0
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-6.5.0/conf folder of the container.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
