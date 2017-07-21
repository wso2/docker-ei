FROM docker.wso2.com/wso2ei:6.1.1

COPY pattern-5/integrator2/carbon/ /mnt/wso2ei-6.1.1
COPY artifacts/mysql-connector-java-5.1.39-bin.jar /mnt/wso2ei-6.1.1/lib/

USER root

RUN chown -R wso2user:wso2 /mnt

RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/rsyncuser --gecos "User" rsyncuser
RUN usermod -aG sudo rsyncuser
RUN adduser rsyncuser sudo
RUN echo "rsyncuser:rsyncuser" | chpasswd

RUN apt-get update && apt-get install -y apt-utils rsync ssh openssh-server sshpass supervisor
RUN mkdir -p  /var/run/sshd /var/log/supervisor
COPY pattern-5/supervisor/supervisord-worker.conf /etc/supervisor/conf.d/supervisord.conf
COPY pattern-5/integrator2/worker-manager-rsync.sh /usr/bin/worker-manager-rsync

RUN chmod +x /usr/bin/worker-manager-rsync

EXPOSE 22

CMD ["/usr/bin/supervisord"]
