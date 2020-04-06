#!/usr/bin/env bash

set -ev

SCRIPT_DIR=`dirname "$0"`
SCRIPT_NAME=`basename "$0"`
SSH_OPTS=-oStrictHostKeyChecking=no

if [[ "$(uname)" == "Darwin" ]]; then
    DOCKER_CMD=docker
else
    DOCKER_CMD="docker"
fi

echo $DOCKER_CMD

if [[ -z $($DOCKER_CMD images | grep test-container) ]] ; then
    echo "Building test container"
    docker build -t test-container $SCRIPT_DIR > /dev/null
fi
echo $PYTHONPATH
python3 --version
echo "Testing $1"
pwd
ls
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
GOPATH=${PWD}/vendor
$DOCKER_CMD run \
    --rm \
    --name test \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $CODE_DIR:$CODE_DIR -w $CODE_DIR \
    -e TRAVIS_JOB_ID=$TRAVIS_JOB_ID \
    -e TRAVIS_BRANCH=$TRAVIS_BRANCH \
    -e TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST \
    -e TRAVIS=$TRAVIS \
    -e GOPATH=$GOPATH \
    test-container \
    sh -c "export PYTHONPATH=\$PYTHONPATH:\$PWD/test ; pwd ; cd test ; sudo python3 ${PWD}/test/$@"

