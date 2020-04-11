#!/usr/bin/env bash

STAGE_CLUSTER_EXISTS=0

     echo "$SERVICE_ACCOUNT_KEY" > key.json
     gcloud auth activate-service-account --key-file=key.json
     gcloud config set project $PROJECT
     gcloud config set container/cluster $CLUSTER_NAME
     gcloud config set compute/zone $REGION-$ZONE_EXTENSION

     STAGE_CLUSTER_EXISTS=$(gcloud container clusters list | grep -c ${CLUSTER_NAME})

     if [[ $STAGE_CLUSTER_EXISTS == 0 ]]; then
        echo "Create cluster"
        gcloud container clusters create $CLUSTER_NAME --enable-autoupgrade --enable-autoscaling --min-nodes=2 --max-nodes=4 --num-nodes=4 --zone=$REGION-$ZONE_EXTENSION
        kubectl create namespace sock-shop
     fi

     gcloud container clusters get-credentials $CLUSTER_NAME --zone $REGION-$ZONE_EXTENSION

     echo "$ARTIFACTORY_AUTH_CONFIG" > art.json
     kubectl create secret generic re01 --from-file=.dockerconfigjson=art.json  --type=kubernetes.io/dockerconfigjson --namespace=sock-shop
