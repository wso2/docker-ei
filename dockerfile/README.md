# Dockerfiles for WSO2 Enterprise Integrator #
This section defines dockerfiles and step-by-step instructions to build docker images for multiple run-times <br>
provided by WSO2 Enterprise Integrator 6.1.1, namely : <br>
1. Integrator
2. Business-process
3. Broker
4. Msf4j
5. Analytics

## How to build an image and run
##### 1. Checkout this repository into your local machine using the following git command.
```
git clone https://github.com/wso2/docker-ei.git
```

>The local copy of the `dockerfile` directory will be referred to as `DOCKERFILE_HOME` from this point onwards.

##### 2. Add JDK and WSO2 Enterprise Integrator distributions to `<DOCKERFILE_HOME>/base/files`
- Download [JDK 1.8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) 
and copy that to `<DOCKERFILE_HOME>/base/files`.
- Download [WSO2 Enterprise Integrator 6.1.1 distribution](https://wso2.com/integration) 
and copy that to `<DOCKERFILE_HOME>/base/files`. <br>
>Please refer to [WSO2 Update Manager documentation](https://docs.wso2.com/display/ADMIN44x/Updating+WSO2+Products)
in order to obtain latest bug fixes and updates for the product.

##### 3. Build the base docker image.
- For base, navigate to `<DOCKERFILE_HOME>/base` directory. <br>
  Execute `docker build` command as shown below.
    + `docker build -t wso2ei-base:6.1.1 .`
        
##### 4. Build docker images specific to each run-time.
- For integrator, navigate to `<DOCKERFILE_HOME>/integrator` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-integrator:6.1.1 .`
- For business-process, navigate to `<DOCKERFILE_HOME>/business-process` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-business-process:6.1.1 .`
- For broker, navigate to `<DOCKERFILE_HOME>/broker` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-broker:6.1.1 .`
- For msf4j, navigate to `<DOCKERFILE_HOME>/msf4j` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-msf4j:6.1.1 .`
- For analytics, navigate to `<DOCKERFILE_HOME>/analytics` directory. <br>
  Execute `docker build` command as shown below. 
    + `docker build -t wso2ei-analytics:6.1.1 .`
    
##### 5. Running docker images specific to each run-time.
- For integrator,
    + `docker run -p 8280:8280 -p 8243:8243 -p 9443:9443 wso2ei-integrator:6.1.1`
- For business-process,
    + `docker run -p 9445:9445 wso2ei-business-process:6.1.1`  
- For broker,
    + `docker run -p 9446:9446 -p 5675:5675 ...all-port-mappings-here... wso2ei-broker:6.1.1` 
- For msf4j,
    + `docker run -p 9090:9090 wso2ei-msf4j:6.1.1`
- For analytics,
    + `docker run -p 9444:9444 -p 9612:9612 -p 9712:9712 wso2ei-msf4j:6.1.1`

##### 6. Accessing management console per each run-time.
- For integrator,
    + `https:<DOCKER_HOST>:9443/carbon`
- For business-process,
    + `https:<DOCKER_HOST>:9445/carbon`
- For broker,
    + `https:<DOCKER_HOST>:9446/carbon`
- For analytics,
    + `https:<DOCKER_HOST>:9444/carbon`
    
>In here, <DOCKER_HOST> refers to hostname or IP of the host machine on top of which containers are spawned.

## Modifying configurations of a container runtime
Configurations would lie on the Docker host machine and they can be volume mounted to the container. <br>
As an example, steps required to change the port offset of integrator runtime using `carbon.xml` is detailed here.

##### 1. Stop the integrator container if it's already running.
In WSO2 Enterprise Integrator 6.1.1 product distribution, carbon.xml file for the integrator runtime <br>
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
wso2ei-integrator:6.1.1
```

>In here, <TARGET_CONFIGS> refers to /home/wso2carbon/wso2ei-6.1.1/conf folder of the container.
