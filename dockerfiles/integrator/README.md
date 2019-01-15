# Dockerfile for Integrator profile of WSO2 Enterprise Integrator #
This section defines the step-by-step instructions to build an [Ubuntu](https://hub.docker.com/_/ubuntu/) Linux based Docker image
Integrator profile for WSO2 Enterprise Integrator 6.3.0.

## Prerequisites

* [Docker](https://www.docker.com/get-docker) v17.09.0 or above


## How to build an image and run
##### 1. Checkout this repository into your local machine using the following Git command.
```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfiles/integrator` directory will be referred to as `INTEGRATOR_DOCKERFILE_HOME` from this point onwards.

##### 2. Add JDK, Integrator profile distributions and MySQL connector to `<INTEGRATOR_DOCKERFILE_HOME>/files`.

- Download [JDK 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and
extract into `<INTEGRATOR_DOCKERFILE_HOME>/files`.
- Download [WSO2 Enterprise Integrator 6.3.0 distribution](https://wso2.com/integration/) distribution.
Extract the product distribution and execute the `<EI_HOME>/bin/profile-creator.sh` to generate the Integrator
profile distribution.

```
./<EI_HOME>/bin/profile-creator.sh
``` 

Extract the generated profile distribution to `<INTEGRATOR_DOCKERFILE_HOME>/files`.
- Download [MySQL Connector/J](https://downloads.mysql.com/archives/c-j)
and copy that to `<INTEGRATOR_DOCKERFILE_HOME>/files`.
- Download [Andes Client](http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/andes/wso2/andes-client/3.2.64/) JAR v3.2.64,
[Geronimo JMS Spec](http://maven.wso2.org/nexus/content/groups/wso2-public/org/apache/geronimo/specs/wso2/geronimo-jms_1.1_spec/1.1.0.wso2v1/) JAR v1.1.0.wso2v1 and
[Secure-vault](http://maven.wso2.org/nexus/content/groups/wso2-public/org/wso2/securevault/org.wso2.securevault/1.0.0-wso2v2/) JAR v.1.0.0-wso2v2 <br> to 
`<INTEGRATOR_DOCKERFILE_HOME>/files/lib`. These libraries are needed for the communication between Integrator <br> and Message Broker.

- Once all of these are in place, it should look as follows:

  ```bash
  <INTEGRATOR_DOCKERFILE_HOME>/files/jdk<version>/
  <INTEGRATOR_DOCKERFILE_HOME>/files/wso2ei-6.3.0/
  <INTEGRATOR_DOCKERFILE_HOME>/files/mysql-connector-java-<version>-bin.jar
  <INTEGRATOR_DOCKERFILE_HOME>/files/lib/andes-client-3.2.64.jar
  <INTEGRATOR_DOCKERFILE_HOME>/files/lib/geronimo-jms_1.1_spec-1.1.0.wso2v1.jar
  <INTEGRATOR_DOCKERFILE_HOME>/files/lib/org.wso2.securevault-1.0.0-wso2v2-sources.jar
  ```
  
>Please refer to [WSO2 Update Manager documentation]( https://docs.wso2.com/display/WUM300/WSO2+Update+Manager)
in order to obtain latest bug fixes and updates for the product.

##### 3. Build the Docker image.
- Navigate to `<INTEGRATOR_DOCKERFILE_HOME>` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-integrator:6.3.0 .`
    
##### 4. Running the Docker image.
- `docker run -p 8280:8280 -p 8243:8243 -p 9443:9443 wso2ei-integrator:6.3.0`

##### 5. Accessing management console.
- To access the management console, use the docker host IP and port 9443.
    + `https:<DOCKER_HOST>:9443/carbon`
    
>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.


## How to update configurations
Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset using `carbon.xml` is as follows.

##### 1. Stop the Broker profile container if it's already running.
In Integrator profile product distribution, `carbon.xml` configuration file can be found at `<DISTRIBUTION_HOME>/conf`.
Copy the file to some suitable location of the host machine, referred to as `<SOURCE_CONFIGS>/carbon.xml` and change
the offset value under ports to 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/carbon.xml`
```
chmod o+r <SOURCE_CONFIGS>/carbon.xml
```

##### 3. Run the image by mounting the file to container as follows.
```
docker run \
-p 9444:9444 \
--volume <SOURCE_CONFIGS>/carbon.xml:<TARGET_CONFIGS>/carbon.xml \
wso2ei-integrator:6.3.0
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-6.3.0/conf folder of the container.


## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
