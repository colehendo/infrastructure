#!/bin/bash

function check_for_existing_cluster() {
    if kops get cluster --name "${KOPS_CLUSTER_NAME}" >/dev/null 2>&1; then
        printf "\n${RED}${KOPS_CLUSTER_NAME} already exists. Please reattempt using a new cluster name.\n"
        exit 1
    fi
}

function initialize_cluster() {
    echo -e "\n${GREEN}Initializing cluster...${NO_COLOR}\n\n"
    if ! kops create cluster \
        --cloud 'aws' \
        --container-runtime 'containerd' \
        --dns-zone "${DOMAIN}" \
        --master-count "${MASTER_COUNT}" \
        --master-size "${MASTER_SIZE}" \
        --master-volume-size "${MASTER_VOLUME_SIZE}" \
        --master-zones "${KOPS_ZONES}" \
        --name "${KOPS_CLUSTER_NAME}" \
        --node-count "${NODE_COUNT}" \
        --node-size "${NODE_SIZE}" \
        --node-volume-size "${NODE_VOLUME_SIZE}" \
        --state "${KOPS_STATE_STORE}" \
        --zones "${KOPS_ZONES}"; then

        exit 1
    fi
    echo -e "\n${GREEN}Cluster initialized.${NO_COLOR}\n"
}

function create_cluster() {
    echo -e "\n${GREEN}Creating cluster...${NO_COLOR}\n\n"
    if ! kops update cluster \
        --name "${KOPS_CLUSTER_NAME}" \
        --yes; then

        exit 1
    fi
    echo -e "\n${GREEN}Cluster created.${NO_COLOR}\n"
}

function wait_for_cluster_to_validate() {
    local timeout=$((20 * 60))
    local sleep_period=10
    local attempts=0
    local max_attempts=$((${timeout} / ${sleep_period}))

    while [[ "${attempts}" -lt "${timeout}" ]]; do
        if kops validate cluster --name "${KOPS_CLUSTER_NAME}" >/dev/null 2>&1; then
            echo -e "${GREEN}Cluster validated successfully!${NO_COLOR}"
            return
        fi
        echo -e "${GREEN}[$(date +%Y%m%d.%H%M%S)]${NO_COLOR} Waiting for cluster validation...\n"
        attempts=$((${attempts} + 1))
        sleep "${sleep_period}"
    done

    echo -e "${RED}Timed out after ${timeout} seconds waiting for cluster validation."
    exit 1
}

. ../utils/export-print-colors.sh

. utils/validate-args.sh "${@}"
. ../utils/export-environment-vars.sh "${@}" --action 'create'

check_for_existing_cluster
initialize_cluster
create_cluster
wait_for_cluster_to_validate

# TODO:
# auth access