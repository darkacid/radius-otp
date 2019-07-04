FROM centos:latest
MAINTAINER Serg <sergstep314@gmail.com>
RUN yum update -y
RUN yum install epel-release -y
RUN yum install freeradius google-authenticator vim-enhanced -y
RUN yum clean all -y
RUN ln -s ../mods-available/pam /etc/raddb/mods-enabled/pam
COPY config/ /etc/
RUN echo "DEFAULT Auth-Type := PAM" >> /etc/raddb/users
RUN  useradd -m test -p $(openssl passwd -1 test)
COPY users/ /home/
RUN chown -R test:test /home/*
RUN cd /etc/raddb; \
chmod 640 sites-enabled/default clients.conf radiusd.conf users; \
chown -h root:radiusd sites-enabled sites-enabled/default clients.conf radiusd.conf users mods-enabled/pam
EXPOSE 1812/udp
CMD radiusd -X
