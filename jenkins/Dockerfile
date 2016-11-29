FROM jenkins:2.19.3
MAINTAINER "Matt Gartman <mattgartman@gmail.com>"

#default jenkins images runs under jenkins user uid 1000.  When using EFS docker creates the mount as root
# which then causes the container jenkins users to not have access, this is a workaround.
# issue presents with ECS task not having access to /mnt/efs/jenkins/*
#see https://github.com/jenkinsci/docker/issues/177 

USER root
ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

#switch to jenkins to customize
#USER jenkins
#COPY groovies/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
#COPY plugins.txt /usr/share/jenkins/ref/
#RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

#switch to root to run
USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["jenkins", "/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
