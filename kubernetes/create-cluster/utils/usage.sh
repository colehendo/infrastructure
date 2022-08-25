#!/bin/bash

function print_usage() {
    echo
    echo "Creates a new Kubernetes Cluster using Kops"
    echo
    echo "Usage:"
    echo
    echo "./create-cluster.sh [OPTIONS]"
    echo
    echo
    echo "Options:"
    echo
    echo "--cluster-name [NAME] (required)"
    echo "      Sets the name of the cluster to NAME.domain"
    echo "--domain [DOMAIN]"
    echo "      Sets the domain name for the cluster like name.DOMAIN"
    echo "      Default: 'colehendo.com'"
    echo "--master-count [COUNT]"
    echo "      Sets the initial number of master nodes"
    echo "      Default: '1'"
    echo "--master-size [INSTANCE TYPE]"
    echo "      Sets the instance type of the master nodes"
    echo "      Default: 't2.micro'"
    echo "--master-volume-size [VOLUME SIZE (GB)]"
    echo "      Sets the size in GB of the volume for the master nodes. Value MUST be 8 or larger"
    echo "      Default: '10'"
    echo "--node-count [COUNT]"
    echo "      Sets the initial number of worker nodes"
    echo "      Default: '1'"
    echo "--node-size [INSTANCE TYPE]"
    echo "      Sets the instance type of the worker nodes"
    echo "      Default: 't2.micro'"
    echo "--node-volume-size [VOLUME SIZE (GB)]"
    echo "      Sets the size in GB of the volume for the worker nodes. Value MUST be 8 or larger"
    echo "      Default: '10'"
    echo "--state-bucket [BUCKET NAME]"
    echo "      Sets the name of the AWS S3 Bucket used for the Kops state to s3://BUCKET NAME"
    echo "      Default: 'colehendo-cluster-state-store'"
    echo "--zones [ZONE NAME(S)]"
    echo "      Sets the name of one or more AWS zones used for associated AWS resources. Comma separated list"
    echo "      Default: 'us-west-1c'"
    echo
}

print_usage
