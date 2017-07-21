from mysql:5.5

COPY artifacts/my.cnf /etc/mysql/conf.d/
COPY artifacts/wso2ei-rdbms.sql /docker-entrypoint-initdb.d/
COPY artifacts/wso2ei-analytics-rdbms.sql /docker-entrypoint-initdb.d/
COPY artifacts/wso2ei-metrics-rdbms.sql /docker-entrypoint-initdb.d/
