FROM docker.io/openjdk:8-jdk-alpine

WORKDIR /opt/

RUN mkdir /opt/devops-demo

ADD demo.tar.gz /opt/devops-demo

WORKDIR /opt/devops-demo/bin

RUN chmod 755 /opt/devops-demo/bin/*.sh

CMD ["sh", "/opt/devops-demo/bin/start.sh"]