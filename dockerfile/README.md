# Dockerfile for WSO2 Enterprise Integrator #
The Dockerfile defines the resources and instructions to build the Docker images with the WSO2 products and runtime configurations.

## Try it out

The downloaded or cloned local copy of WSO2 Enterprise Integrator Docker artifacts will be referred as `DOCKER_HOME`.

* Add product packs and dependencies
    - Download and copy JDK 1.8 ([jdk-8u131-linux-x64.tar.gz](http://www.oracle.com/technetwork/java/javase/8u131-relnotes-3565278.html)) pack to `<DOCKER_HOME>/dockerfile/common/provision/default/files`.
    - Download the WSO2 Enterprise Integrator 6.1.1 zip file (http://wso2.com/integration/) and copy it to `<DOCKER_HOME>/dockerfile/common/provision/default/files`.

* Build the docker image
    - Navigate to `<DOCKER_HOME>/dockerfile`.
    - Execute `build.sh` script and provide the product version.
        +  `./build.sh `
```bash
        Usage: ./build.sh 

        Options:
        
          -l	[OPTIONAL] '|' separated WSO2EI profiles to build. All the profiles are selected if no value is specified.
          -i	[OPTIONAL] Docker image version.
          -e	[OPTIONAL] Product environment. If not specified this is defaulted to "dev".
          -o	[OPTIONAL] Preferred organization name. If not specified, will be kept empty.
          -q	[OPTIONAL] Quiet flag. If used, the docker build run output will be suppressed.
          -r	[OPTIONAL] Provisioning method. If not specified this is defaulted to "default". Available provisioning methods are puppet, default.
          -t	[OPTIONAL] Image name. If this is specified, it will be used as the image name instead of "wso2{product}" format.
          -y	[OPTIONAL] Automatic yes to prompts; assume "y" (yes) as answer to all prompts and run non-interactively.
          -s	[OPTIONAL] Platform to be used to run the Dockerfile (ex.: kubernetes). If not specified will assume the value as 'default'.
          -p	[OPTIONAL] Deployment pattern number. If the pattern is not specified pattern "1" will be used.
          -m	[OPTIONAL] Puppet module name. If the module name is not specified "product name" will be used.
        
        Ex: ./build.sh -p 2 -r puppet -l integrator|analytics|business-process|broker
        Ex: ./build.sh -l integrator|analytics|business-process|broker -o myorganization -i 1.0.0
        Ex: ./build.sh -t wso2ei-customized
```

* Docker run
    - Navigate to `<DOCKER_HOME>/dockerfile`.
    - Execute `run.sh` script and provide the product version.
        + `./run.sh `
```bash 
        Usage: ./run.sh

        Options:

          -i	[OPTIONAL] Docker image version.
          -l	[OPTIONAL] '|' separated WSO2EI profiles to run. 'default' is selected if no value is specified.
          -o	[OPTIONAL] Organization name. 'wso2' is selected if no value is specified.
          -p	[OPTIONAL] [MULTIPLE] Port mappings for the exposed ports 9612 9712 7712 7612 9764 9444 of the container 
          -k	[OPTIONAL] The keystore password if SecureVault was enabled in the product.
          -m	[OPTIONAL] Full path of the host location to share with containers.
        
        Ex: ./run.sh -v 6.1.1 -l 'integrator' -k 'wso2carbon'
```

* Access management console
    -  To access the management console, use the docker host IP and port 9443.
        + `https://<DOCKER_HOST_IP>:9443/carbon`
