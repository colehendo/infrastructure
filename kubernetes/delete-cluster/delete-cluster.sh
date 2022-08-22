#!/bin/bash

function delete_cluster() {
    kops delete cluster \
        --name "${KOPS_CLUSTER_NAME}" \
        --yes
}

. ../utils/export-print-colors.sh

. validate-args.sh "${@}"
. ../utils/export-environment-vars.sh "${@}"

delete_cluster
