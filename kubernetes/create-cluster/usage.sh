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
    echo "      Sets the name of the cluster to NAME.domain.com"
    echo "--domain [DOMAIN]"
    echo "      Sets the domain name for the cluster like name.DOMAIN.com"
    echo "      Default: 'colehendo'"
    echo "--oicd-bucket [BUCKET NAME]"
    echo "      Sets the name of the AWS S3 Bucket used for OICD auth to s3://BUCKET NAME"
    echo "      Default: 'colehendo-cluster-oidc-store'"
    echo "--state-bucket [BUCKET NAME]"
    echo "      Sets the name of the AWS S3 Bucket used for the Kops state to s3://BUCKET NAME"
    echo "      Default: 'colehendo-cluster-state-store'"
    echo "--zone [ZONE NAME]"
    echo "      Sets the name of the AWS zone used for associated AWS resources"
    echo "      Default: 'us-west-1c'"
    echo
}

print_usage
