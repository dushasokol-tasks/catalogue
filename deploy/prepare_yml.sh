#!/usr/bin/env bash

stage_cluster_name=''

     echo "$SERVICE_ACCOUNT_KEY" > key.json
     gcloud auth activate-service-account --key-file=key.json
     gcloud config set project $PROJECT
     gcloud config set container/cluster $CLUSTER_NAME
     gcloud config set compute/zone $REGION-$ZONE_EXTENSION

     stage_cluster_name = result=$(gcloud container clusters list | grep -c "${CLUSTER_NAME}")


     echo stage_cluster_name

     if [[ $stage_cluster_name != $CLUSTER_NAME ]]; then
        gcloud container clusters create $CLUSTER_NAME --enable-autoupgrade --enable-autoscaling --min-nodes=2 --max-nodes=4 --num-nodes=4 --zone=$REGION-$ZONE_EXTENSION
        kubectl create namespace sock-shop
     fi
     
     gcloud container clusters get-credentials $CLUSTER_NAME --zone $REGION-$ZONE_EXTENSION
