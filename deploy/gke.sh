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
        gcloud container clusters create $CLUSTER_NAME --enable-autoupgrade --enable-autoscaling --min-nodes=1 --max-nodes=2 --num-nodes=2 --zone=$REGION-$ZONE_EXTENSION
        kubectl create namespace sock-shop
     fi

     gcloud container clusters get-credentials $CLUSTER_NAME --zone $REGION-$ZONE_EXTENSION

