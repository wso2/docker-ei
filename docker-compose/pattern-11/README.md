### WSO2 Enterprise Integrator Pattern-11 deployment with Docker compose

![pattern-design](../patterns/design/wso2ei-6.1.1-pattern-11.png)

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

Navigate to `<DOCKER_HOME>/docker-compose/pattern-11`

```
docker login docker.wso2.com 

docker-compose up -d
```

This will deploy the following,

* Mysql server (container) with `WSO2_CONFIG_DB, WSO2_REG_DB, WSO2_USER_DB, WSO2_ANALYTICS_EVENT_STORE_DB, WSO2_ANALYTICS_PROCESSED_DATA_STORE_DB, WSO2_METRICS_DB, WSO2_BPMN_DB, WSO2_BPM_DB WSO2_MB_STORE_DB and WSO2_METRICS_DB`
* Two Integrator profile containers run as cluster
* Two Analytics profile containers run as cluster
* Two Business process profile containers run as cluster
* Two Broker profile containers run as cluster
* Nginx Load Balancer container

#### How to test

Add the following entries to the /etc/hosts
```
127.0.0.1 ui.integrator.wso2.com integrator.wso2.com 
127.0.0.1 ui.analytics.wso2.com analytics.wso2.com 
127.0.0.1 ui.business-process.wso2.com business-process.wso2.com 
127.0.0.1 ui.broker.wso2.com broker.wso2.com
```

If you are using docker machine, please use the docker machine IP instead of the local machine IP.

#### How to access the environment

Integrator carbon management console

```
https://ui.integrator.wso2.com/carbon
```

Analytics carbon management console

```
https://ui.integrator.wso2.com/carbon
```

Business process carbon management console

```
https://ui.business-process.wso2.com/carbon
```

Broker carbon management console

```
https://ui.broker.wso2.com/carbon
```
