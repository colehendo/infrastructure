#!/bin/bash

DOMAIN='colehendo'
OICD_BUCKET='colehendo-cluster-oidc-store'
STATE_BUCKET='colehendo-cluster-state-store'
SUBDOMAIN=''
ZONE='us-west-1c'

function handle_unrecognized_arg() {
    echo -e "${RED}${1} is an unrecognized argument.${NO_COLOR}\n"
}

# TODO: handle unrecognized args
function parse_args() {
    while [ "${#}" -gt 0 ]; do
        case "${1}" in
        --cluster-name)
            SUBDOMAIN="${2}"
            shift
            ;;
        --domain)
            DOMAIN="${2}"
            shift
            ;;
        --oicd-bucket)
            OICD_BUCKET="${2}"
            shift
            ;;
        --state-bucket)
            STATE_BUCKET="${2}"
            shift
            ;;
        --zone)
            ZONE="${2}"
            shift
            ;;
        *)
            handle_unrecognized_arg "${1}"
            shift
            ;;
        esac
        shift
    done
}

function set_aws_cli_keys() {
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile kops)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile kops)
}

function set_cluster_name() {
    export KOPS_CLUSTER_NAME="${SUBDOMAIN}.${DOMAIN}.com"
}

function set_store_buckets() {
    export KOPS_STATE_STORE="s3://${STATE_BUCKET}"
    export KOPS_OICD_STORE="s3://${OICD_BUCKET}"
}

function set_zones() {
    export KOPS_ZONES="${ZONE}"
}

parse_args "${@}"

echo "Setting environment variables for execution..."

set_aws_cli_keys
set_cluster_name
set_store_buckets
set_zones
