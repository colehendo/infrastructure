#!/bin/bash

ACTION=''

DOMAIN='colehendo.com'
STATE_BUCKET='colehendo-cluster-state-store'
SUBDOMAIN=''
ZONES='us-west-1c'

MASTER_COUNT='1'
MASTER_SIZE='t2.micro'
MASTER_VOLUME_SIZE='10'
NODE_COUNT='1'
NODE_SIZE='t2.micro'
NODE_VOLUME_SIZE='10'

function parse_global_args() {
    while [ "${#}" -gt 0 ]; do
        case "${1}" in
        --action)
            ACTION="${2}"
            shift
            ;;
        --cluster-name)
            SUBDOMAIN="${2}"
            shift
            ;;
        --state-bucket)
            STATE_BUCKET="${2}"
            shift
            ;;
        esac
        shift
    done
}

function parse_create_args() {
    while [ "${#}" -gt 0 ]; do
        case "${1}" in
        --domain)
            DOMAIN="${2}"
            shift
            ;;
        --master-count)
            MASTER_COUNT="${2}"
            shift
            ;;
        --master-size)
            MASTER_SIZE="${2}"
            shift
            ;;
        --master-volume-size)
            MASTER_VOLUME_SIZE="${2}"
            shift
            ;;
        --node-count)
            NODE_COUNT="${2}"
            shift
            ;;
        --node-size)
            NODE_SIZE="${2}"
            shift
            ;;
        --node-volume-size)
            NODE_VOLUME_SIZE="${2}"
            shift
            ;;
        --zones)
            ZONES="${2}"
            shift
            ;;
        esac
        shift
    done
}

function set_cluster_name() {
    export KOPS_CLUSTER_NAME="${SUBDOMAIN}.${DOMAIN}"
}

function set_buckets() {
    export KOPS_STATE_STORE="s3://${STATE_BUCKET}"
}

# Create functions

function set_aws_cli_keys() {
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile kops)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile kops)
}

function set_instance_vars() {
    export MASTER_COUNT="${MASTER_COUNT}"
    export MASTER_SIZE="${MASTER_SIZE}"
    export MASTER_VOLUME_SIZE="${MASTER_VOLUME_SIZE}"
    export NODE_COUNT="${NODE_COUNT}"
    export NODE_SIZE="${NODE_SIZE}"
    export NODE_VOLUME_SIZE="${NODE_VOLUME_SIZE}"
}

function set_zones() {
    export KOPS_ZONES="${ZONES}"
}

function set_global_vars() {
    set_cluster_name
    set_buckets
}

function call_create_functions() {
    set_aws_cli_keys
    set_instance_vars
    set_zones
}

function handle_actions() {
    if [[ "${ACTION}" == 'create' ]]; then
        parse_create_args "${@}"
        call_create_functions
    fi
}

echo "Setting environment variables for execution..."

parse_global_args "${@}"
set_global_vars
handle_actions "${@}"
