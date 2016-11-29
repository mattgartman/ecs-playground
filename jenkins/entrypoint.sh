#!/bin/bash
#see https://github.com/jenkinsci/docker/issues/177
set -e
chown -R 1000:1000 /var/jenkins_home
if [ "$1" = 'jenkins' ]; then
    chown -R jenkins:jenkins "$JENKINS_HOME"
    exec gosu "$@"
fi
exec "$@"