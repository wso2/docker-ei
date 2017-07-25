### WSO2 Enterprise Integrator Pattern-4 deployment with Docker compose

![pattern-design](../patterns/design/wso2ei-6.1.1-pattern-4.png)

#### Pre-requisites

 * Docker
 * Docker compose

#### Docker installation for linux
```
wget -qO- https://get.docker.com/ | sh
```

#### Docker installation for Mac

https://docs.docker.com/docker-for-mac/

#### Docker installation for Windows

https://docs.docker.com/docker-for-windows/

#### Docker Compose Installation

https://docs.docker.com/compose/install/

#### How to run

The downloaded or cloned local copy of WSO2 Enterprise Integrator Docker artifacts will be referred as `DOCKER_HOME`.

Navigate to `<DOCKER_HOME>/docker-compose/pattern-4`

```
docker login docker.wso2.com 

docker-compose up -d
```

This will deploy the following,

* Mysql server (container) with `WSO2_CONFIG_DB, WSO2_REG_DB, WSO2_USER_DB, WSO2_MB_STORE_DB and WSO2_METRICS_DB`
* Broker profile container 

#### How to test

Add the following entries to the /etc/hosts
```
127.0.0.1 broker
```

If you are using docker machine, please use the docker machine IP instead of the local machine IP.

#### How to access the environment

Broker carbon management console

```
https://broker:9446/carbon
```
