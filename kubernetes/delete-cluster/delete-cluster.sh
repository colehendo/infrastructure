#!/bin/bash

function delete_cluster() {
    if ! kops delete cluster \
        --name "${KOPS_CLUSTER_NAME}" \
        --state "${KOPS_STATE_STORE}" \
        --yes; then

        exit 1
    fi
}

. ../utils/export-print-colors.sh

. validate-args.sh "${@}"
. ../utils/export-environment-vars.sh "${@}"

delete_cluster
