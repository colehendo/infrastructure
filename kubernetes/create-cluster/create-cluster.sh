#!/bin/bash

function check_for_existing_cluster() {
    if kops get cluster --name "${KOPS_CLUSTER_NAME}"; then
        printf "\n${RED}${KOPS_CLUSTER_NAME} already exists. Please reattempt using a new cluster name.\n"
        exit 1
    fi
}

function initialize_cluster() {
    kops create cluster \
        --cloud 'aws' \
        --container-runtime 'containerd' \
        --discovery-store "${KOPS_OICD_STORE}/${NAME}/discovery" \
        --master-count 1 \
        --master-size 't2.micro' \
        --master-volume-size 10 \
        --master-zones "${KOPS_ZONES}" \
        --name "${KOPS_CLUSTER_NAME}" \
        --node-count 1 \
        --node-size 't2.micro' \
        --node-volume-size 10 \
        --zones "${KOPS_ZONES}"
}

function create_cluster() {
    kops update cluster \
        --name "${KOPS_CLUSTER_NAME}"
    --yes
}

function wait_for_cluster_to_validate() {
    timeout=$((20 * 60))
    sleep_period=10
    attempts=0
    max_attempts=$((${timeout} / ${sleep_period}))

    while [[ "${attempts}" -lt "${timeout}" ]]; do
        if kops validate cluster --name "${KOPS_CLUSTER_NAME}" >/dev/null; then
            echo -e "${GREEN}Cluster validated successfully!${NO_COLOR}"
            return
        fi
        echo -e "${GREEN}[$(date +%Y%m%d.%H%M%S)]${NO_COLOR} Waiting for cluster validation...\n"
        attempts+=1
        sleep ${sleep_period}
    done

    echo -e "${RED}Timed out after ${timeout} seconds waiting for cluster validation."
    exit 1
}

. ../utils/export-print-colors.sh

. validate-args.sh "${@}"
. ../utils/export-environment-vars.sh "${@}"

check_for_existing_cluster
create_cluster
wait_for_cluster_to_validate
