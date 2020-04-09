#!/usr/bin/env sh

set -ev

SCRIPT_DIR=`dirname "$0"`
SCRIPT_NAME=`basename "$0"`
SSH_OPTS=-oStrictHostKeyChecking=no

if [[ "$(uname)" == "Darwin" ]] || [[ $GITLAB_OVERLAY == 1 ]]; then
    DOCKER_CMD=docker
else
    DOCKER_CMD="sudo docker"
fi

echo $DOCKER_CMD

if [[ -z $($DOCKER_CMD images | grep test-container) ]] ; then
    echo "Building test container"
    docker build -t test-container $SCRIPT_DIR > /dev/null
fi

#echo ${PYTHONPATH}
#go version
# echo $SCRIPT_DIR


echo "Testing $1"

CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
GOPATH=${PWD}/vendor

echo "dirs"
echo "codedir $CODE_DIR"
echo "scriptdir $SCRIPT_DIR"

$DOCKER_CMD run \
    -it \
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
    sh "ls;"


#sh -c "export PYTHONPATH=\$PYTHONPATH:\$PWD/test ; ls;"
    #sh -c "export PYTHONPATH=\$PYTHONPATH:\$PWD/test ; ls; pwd; python test/$@"
