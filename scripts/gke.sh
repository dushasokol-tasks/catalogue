#!/bin/bash
# This bash script shall create a GKE cluster, an external IP, setup kubectl to
# connect to the cluster without changing the home kube config and finally installs
# helm with the appropriate service account if RBAC is enabled

set -e

echo "debug"

REGION=${REGION-us-central1}
ZONE_EXTENSION=${ZONE_EXTENSION-b}
ZONE=${REGION}-${ZONE_EXTENSION}
CLUSTER_NAME=${CLUSTER_NAME-gitlab-cluster}
MACHINE_TYPE=${MACHINE_TYPE-n1-standard-4}
RBAC_ENABLED=${RBAC_ENABLED-true}
NUM_NODES=${NUM_NODES-2}
INT_NETWORK=${INT_NETWORK-default}
PREEMPTIBLE=${PREEMPTIBLE-false}
EXTRA_CREATE_ARGS=${EXTRA_CREATE_ARGS-""}
USE_STATIC_IP=${USE_STATIC_IP-false};
external_ip_name=${CLUSTER_NAME}-external-ip;
