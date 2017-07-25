FROM docker.wso2.com/wso2ei-broker:6.1.1

COPY pattern-8/broker2/carbon/ /mnt/wso2ei-6.1.1/wso2/broker

COPY artifacts/mysql-connector-java-5.1.39-bin.jar /mnt/wso2ei-6.1.1/lib/

USER root

RUN chown -R wso2user:wso2 /mnt
