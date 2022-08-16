#!/bin/bash

function create_cluster() {
    kops create cluster \
        --cloud 'aws' \
        --container-runtime 'containerd' \
        --discovery-store "${KOPS_OICD_STORE}/${NAME}/discovery" \
        --master-count 10 \
        --master-size 't2.micro' \
        --master-volume-size 1 \
        --master-zones "${KOPS_ZONES}" \
        --name "${KOPS_CLUSTER_NAME}" \
        --node-count 1 \
        --node-size 't2.micro' \
        --node-volume-size 10 \
        --zones "${KOPS_ZONES}" \
        --yes
}

. export-environment-vars.sh
create_cluster