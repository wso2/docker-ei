# Dockerfile for WSO2 EI Analytics Server #

This section defines the step-by-step instructions to build an [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker image for analytics runtime of WSO2 EI Analytics 7.1.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client

## How to build an image and run

##### 1. Checkout this repository into your local machine using the following Git client command.

```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfiles/ubuntu/ei-analytics/server` directory will be referred to as `ANALYTICS_SERVER_DOCKERFILE_HOME` from this point onwards.

##### 2. Build the Docker image.

- Navigate to `<ANALYTICS_SERVER_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-analytics-server:7.1.0 .`

> By default, the Docker image will prepackage the General Availability (GA) release version of the relevant WSO2 product.

##### 3. Running the Docker image.

- `docker run -p 7612:7612 -p 7712:7712 wso2ei-analytics-server:7.1.0`

```
As a shared database is needed for EI Analytics dashboard and the server, 
the datasource configuration should be added in the deployment.yaml file for EI_ANALYTICS datasource
```

## How to update configurations

Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
Steps required to change datasource configuration using `deployment.toml` is as follows:

##### 1. Stop the Analytics Dashboard container if it's already running.

In WSO2 EI Analytics 7.1.0 product distribution, `deployment.yaml` configuration file of server can be found at `<DISTRIBUTION_HOME>/conf/server`.<br>
Copy the file to some suitable location of the host machine, referred to as `<SOURCE_CONFIGS>/deployment.yaml` and change the datasource config:
```xml
      name: EI_ANALYTICS
      description: "The datasource used for EI Analytics dashboard feature"
      jndiConfig:
        name: jdbc/EI_ANALYTICS
      definition:
        type: RDBMS
        configuration:
          jdbcUrl: 'jdbc:mysql://localhost:3306/ei_analytics?useSSL=false'
          username: root
          password: XXXX
          driverClassName: com.mysql.jdbc.Driver
          maxPoolSize: 50
          idleTimeout: 60000
          validationTimeout: 30000
          isAutoCommit: false
```

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/deployment.yaml`.

```
chmod o+r <SOURCE_CONFIGS>/deployment.yaml
```

##### 3. Run the image by mounting the file to container as follows:

```
docker run \
-p 7612:7612 \
-p 7712:7712 \
--volume <SOURCE_CONFIGS>/deployment.yaml:<TARGET_CONFIGS>/ddeployment.yaml \
wso2ei-analytics-server:7.1.0
```

> In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-analytics-7.1.0/conf/server folder of the container.

## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
