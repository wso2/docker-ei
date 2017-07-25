FROM docker.wso2.com/wso2ei-analytics:6.1.1

COPY pattern-2/analytics/carbon/ /mnt/wso2ei-6.1.1/wso2/analytics
COPY artifacts/mysql-connector-java-5.1.39-bin.jar /mnt/wso2ei-6.1.1/lib/

USER root

RUN chown -R wso2user:wso2 /mnt
