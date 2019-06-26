# Dockerfile for Dashboard Profile of WSO2 Enterprise Integrator Analytics #

This section defines the step-by-step instructions to build an [Alpine](https://hub.docker.com/_/alpine/) Linux based Docker images
for Dashboard Profile of WSO2 Enterprise Integrator 6.5.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfile/ubuntu/analytics/dashboard` directory will be referred to as `ANALYTICS_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<ANALYTICS_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-analytics-dashboard:6.5.0-alpine .`

> By default, the Docker image will prepackage the General Availability (GA) release version of the relevant WSO2 product.
 
##### 3. Running the Docker image.

- `docker run -p 9643:9643 wso2ei-analytics-dashboard:6.5.0-alpine`

> Here, only port 9643 has been mapped to a Docker host port.
You may map other container service ports, which have been exposed to Docker host ports, as desired.

##### 4. Accessing the Dashboard portal.

- For Analytics Dashboard,
    + Business Rules:<br>
    `https://<DOCKER_HOST>:9643/business-rules`
    + Portal:<br>
    `https://<DOCKER_HOST>:9643/portal`
    + Monitoring:<br>
    `https://<DOCKER_HOST>:9643/monitoring`
    
>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `deployment.yaml` is as follows:

##### 1. Stop the Enterprise Integrator Analytics container if it's already running.

In Analytics Worker profile product distribution, `deployment.yaml` configuration file <br>
can be found at `<DISTRIBUTION_HOME>/wso2/analytics/conf/worker`. Copy the file to some suitable location of the host machine, <br>
referred to as `<SOURCE_CONFIGS>/deployment.yaml` and increase the offset value under ports by 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/deployment.yaml`.

```
chmod o+r <SOURCE_CONFIGS>/deployment.yaml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run 
-p 9445:9445
--volume <SOURCE_CONFIGS>/deployment.yaml:<TARGET_CONFIGS>/deployment.yaml
wso2ei-analytics-worker:6.5.0-alpine
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-6.5.0/wso2/analytics/conf/worker folder of the container.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
