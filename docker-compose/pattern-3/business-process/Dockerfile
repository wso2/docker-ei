FROM docker.wso2.com/wso2ei-business-process:6.1.1

COPY pattern-3/business-process/carbon/ /mnt/wso2ei-6.1.1/wso2/business-process
COPY artifacts/mysql-connector-java-5.1.39-bin.jar /mnt/wso2ei-6.1.1/lib/

USER root

RUN chown -R wso2user:wso2 /mnt
