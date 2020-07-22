# Dockerfile for WSO2 Streaming Integrator #

This section defines the step-by-step instructions to build an [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker image
for WSO2 Streaming Integrator 1.1.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfiles/ubuntu/streaming-integrator` directory will be referred to as `SI_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<SI_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2si:1.1.0 .`

> By default, the Docker image will prepackage the General Availability (GA) release version of the relevant WSO2 product.

##### 3. Running the Docker image.

- `docker run -p 9443:9443 wso2si:1.1.0`
  

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `deployment.yaml` is as follows:

##### 1. Stop the SI container if it's already running.

In SI product distribution, `deployment.yaml` configuration file can be found at `<DISTRIBUTION_HOME>/conf/server`.
Copy the file to some suitable location of the host machine, referred to as `<SOURCE_CONFIGS>/server/deployment.yaml` and
increase the offset value under ports by 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/server/deployment.yaml`.

```
chmod o+r <SOURCE_CONFIGS>/server/deployment.yaml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run \
-p 9444:9444 \
--volume <SOURCE_CONFIGS>/server/deployment.yaml:<TARGET_CONFIGS>/server/deployment.yaml \
wso2si:1.1.0
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2si-1.1.0/conf folder of the container.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
