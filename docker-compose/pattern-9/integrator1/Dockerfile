FROM docker.wso2.com/wso2ei:6.1.1

COPY pattern-9/integrator1/carbon/ /mnt/wso2ei-6.1.1
COPY artifacts/mysql-connector-java-5.1.39-bin.jar /mnt/wso2ei-6.1.1/lib/
COPY artifacts/andes-client-3.2.19.jar /mnt/wso2ei-6.1.1/lib/
COPY artifacts/geronimo-jms_1.1_spec-1.1.0.wso2v1.jar /mnt/wso2ei-6.1.1/lib/
COPY artifacts/org.wso2.securevault-1.0.0-wso2v2.jar /mnt/wso2ei-6.1.1/lib/

USER root

RUN chown -R wso2user:wso2 /mnt

RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/rsyncuser --gecos "User" rsyncuser
RUN usermod -aG sudo rsyncuser
RUN adduser rsyncuser sudo
RUN echo "rsyncuser:rsyncuser" | chpasswd

RUN apt-get update && apt-get install -y apt-utils rsync ssh openssh-server supervisor
RUN mkdir -p  /var/run/sshd /var/log/supervisor
COPY pattern-9/supervisor/supervisord-manager.conf /etc/supervisor/conf.d/supervisord.conf

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22

CMD ["/usr/bin/supervisord"]
