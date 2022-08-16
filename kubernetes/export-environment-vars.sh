#!/bin/bash

function set_aws_cli_keys() {
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile kops)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile kops)
}

function set_cluster_name() {
    export KOPS_CLUSTER_NAME='colehendo.com'
}

function set_store_buckets() {
    export KOPS_STATE_STORE='s3://colehendo-cluster-state-store'
    export KOPS_OICD_STORE='s3://colehendo-cluster-oidc-store'
}

function set_zones() {
    export KOPS_ZONES='us-west-1c'
}

echo "Setting environment variables for execution..."

set_aws_cli_keys
set_cluster_name
set_store_buckets
set_zones