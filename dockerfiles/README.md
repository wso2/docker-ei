# Dockerfiles for WSO2 Enterprise Integrator #
This section defines dockerfiles and step-by-step instructions to build docker images for multiple profiles <br>
provided by WSO2 Enterprise Integrator 6.2.0, namely : <br>
1. Integrator
2. Business Process
3. Broker
4. MSF4J
5. Analytics

## Prerequisites
* [Docker](https://www.docker.com/get-docker) v17.09.0 or above
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) client
* WSO2 Enterprise Integrator pack downloaded through [WUM](https://wso2.com/wum/download)
* Download JDK 8 through [Oracle](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
  - Host the downloaded pack and JDK locally or on a remote location.
>The hosted product pack location and JDK location will be passed as the build arguments WSO2_SERVER_DIST_URL and JDK_URL when building the Docker image.

## How to build an image and run
##### 1. Checkout this repository into your local machine using the following git command.
```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfiles` directory will be referred to as `DOCKERFILE_HOME` from this point onwards.

- If you **DO NOT** intend to use the Docker images with Kubernetes clustered product deployments, comment out
the following lines from `<DOCKERFILE_HOME>/base/Dockerfile` file.
```
# artifacts for Kubernetes membership scheme based clustering
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/dnsjava/dnsjava/2.1.8/dnsjava-2.1.8.jar ${WSO2_SERVER_HOME}/lib/
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/org/wso2/carbon/kubernetes/artifacts/kubernetes-membership-scheme/1.0.5/kubernetes-membership-scheme-1.0.5.jar ${WSO2_SERVER_HOME}/dropins/

```
>Please refer to [WSO2 Update Manager documentation](https://docs.wso2.com/display/ADMIN44x/Updating+WSO2+Products)
in order to obtain latest bug fixes and updates for the product.

##### 2. Build the base docker image.
- For base, navigate to `<DOCKERFILE_HOME>/base` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build --build-arg WSO2_SERVER_DIST_URL=<URL_OF_THE_HOSTED_LOCATION/FILENAME> JDK_URL=<URL_OF_THE_HOSTED_JDK_LOCATION/FILENAME> -t wso2ei-<PROFILE>:6.2.0 .`
    - eg:- Hosted locally: docker build --build-arg WSO2_SERVER_DIST_URL=http://172.17.0.1:8000/wso2ei-6.2.0.zip JDK_URL=http://172.17.0.1:8000/jdk-8u261-linux-x64.tar.gz -t wso2ei-<PROFILE>:6.2.0 . 
    - eg:- Hosted remotely: docker build --build-arg WSO2_SERVER_DIST_URL=http://<public_ip:port>/wso2ei-6.2.0.zip JDK_URL=http://172.17.0.1:8000/jdk-8u261-linux-x64.tar.gz -t wso2ei-<PROFILE>:6.2.0 .
        
##### 3. Build docker images specific to each profile.
- For integrator, navigate to `<DOCKERFILE_HOME>/integrator` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-integrator:6.2.0 .`
- For business process, navigate to `<DOCKERFILE_HOME>/business-process` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-business-process:6.2.0 .`
- For broker, navigate to `<DOCKERFILE_HOME>/broker` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-broker:6.2.0 .`
- For msf4j, navigate to `<DOCKERFILE_HOME>/msf4j` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-msf4j:6.2.0 .`
- For analytics, navigate to `<DOCKERFILE_HOME>/analytics` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-analytics:6.2.0 .`
    
##### 4. Running docker images specific to each profile.
- For integrator,
    + `docker run -p 8280:8280 -p 8243:8243 -p 9443:9443 wso2ei-integrator:6.2.0`
- For business process,
    + `docker run -p 9445:9445 9765:9765 wso2ei-business-process:6.2.0`  
- For broker,
    + `docker run -p 9446:9446 -p 5675:5675 ...all-port-mappings-here... wso2ei-broker:6.2.0` 
- For msf4j,
    + `docker run -p 9090:9090 wso2ei-msf4j:6.2.0`
- For analytics,
    + `docker run -p 9444:9444 -p 9612:9612 -p 9712:9712 wso2ei-analytics:6.2.0`

##### 5. Accessing management console per each profile.
- For integrator,
    + `https:<DOCKER_HOST>:9443/carbon`
- For business process,
    + `https:<DOCKER_HOST>:9445/carbon`
- For broker,
    + `https:<DOCKER_HOST>:9446/carbon`
- For analytics,
    + `https:<DOCKER_HOST>:9444/carbon`
    
>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.


## How to update configurations
Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset of integrator profile using `carbon.xml` is as follows.

##### 1. Stop the integrator container if it's already running.
In WSO2 Enterprise Integrator 6.2.0 product distribution, carbon.xml file for the integrator profile <br>
can be found at `<DISTRIBUTION_HOME>/conf`. Copy the file to some suitable location of the host machine, <br>
referred to as `<SOURCE_CONFIGS>/carbon.xml` and change the offset value under ports to 1.

##### 2. Grant read permission to `other` users for `<SOURCE_CONFIGS>/carbon.xml`
```
chmod o+r <SOURCE_CONFIGS>/carbon.xml
```

##### 3. Run the image by mounting the file to container as follows.
```
docker run 
-p 8281:8281 -p 8244:8244 -p 9444:9444
--volume <SOURCE_CONFIGS>/carbon.xml:<TARGET_CONFIGS>/carbon.xml
wso2ei-integrator:6.2.0
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-6.2.0/conf folder of the container.


## Docker command usage references

* [Docker build command reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Docker run command reference](https://docs.docker.com/engine/reference/run/)
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
