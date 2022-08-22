#!/bin/bash

function print_usage() {
    echo
    echo "Deletes an existing Kubernetes Cluster using Kops"
    echo
    echo "Usage:"
    echo
    echo "./delete-cluster.sh [OPTIONS]"
    echo
    echo
    echo "Options:"
    echo
    echo "--cluster-name [NAME] (required)"
    echo "      Name of the cluster to delete (NAME.domain.com)"
    echo "--domain [DOMAIN]"
    echo "      Domain of the cluster to delete (name.DOMAIN.com)"
    echo "      Default: 'colehendo'"
    echo
}

print_usage
