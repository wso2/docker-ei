# Dockerfile for WSO2 Micro Integrator Dashboard

This section defines the step-by-step instructions to build an [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker image for WSO2 Micro Integrator Dashboard 4.2.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfiles/ubuntu/monitoring-dashboard` directory will be referred to as
> `MONITORING_DASHBOARD_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Download wso2mi-dashboard-4.2.0.zip from [here](https://wso2.com/micro-integrator)
- Host the product pack using a webserver.
- Navigate to `<MONITORING_DASHBOARD_DOCKERFILE_HOME>` directory. <br>
- Change <MI_DASHBOARD_DIST_URL> in Dockerfile to the URL of the product pack.
  Execute `docker build` command as shown below.
    + `docker build -t wso2mi-dashboard:4.2.0 .`

> By default, the Docker image will prepackage the General Availability (GA) release version of the relevant WSO2 product.

##### 3. Running the Docker image.

- `docker run -it -p 9743:9743 wso2mi-dashboard:4.2.0`

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `deployment.toml` is as follows:

##### 1. Stop the MI container if it's already running.

In WSO2 Micro Integrator Monitoring Dashboard 4.2.0 product distribution, `deployment.toml` configuration file can be found at `<DISTRIBUTION_HOME>/conf
/server`.<br>
Copy the file to some suitable location of the host machine, referred to as `<SOURCE_CONFIGS>/deployment.toml` and change the<br>
offset value (`[server]->offset`) to 11.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/deployment.toml`.

```
chmod o+r <SOURCE_CONFIGS>/deployment.toml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run -it \
-p 9744:9744 \
--volume <SOURCE_CONFIGS>/deployment.toml:<TARGET_CONFIGS>/deployment.toml \
wso2mi-dashboard:4.2.0
```

> In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2mi-dashboard-4.2.0/conf/server folder of the
> container.

## WSO2 Private Docker images

If you have a valid WSO2 subscription you can have access to WSO2 private Docker images. These images will get updated frequently with bug fixes, security fixes and new improvements. To view available images visit [WSO2 Docker Repositories](https://docker.wso2.com/)

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
