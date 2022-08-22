#!/bin/bash

function print_usage() {
    . usage.sh
}

function check_for_help() {
    for arg in "${@}"; do
        if [[ "${arg}" == "-h" ]] || [[ "${arg}" == "--help" ]]; then
            print_usage
            exit 0
        fi
    done
}

function validate_args() {
    local args="${@}"
    local required_args=("--cluster-name")
    local missing_required_args=()

    for arg in "${required_args[@]}"; do
        if ! [[ " ${args[*]} " =~ " ${arg} " ]]; then
            missing_required_args+=("${arg}")
        fi
    done

    if [[ "${#missing_required_args}" -gt 0 ]]; then
        echo -e "${RED}"
        echo "ERROR!"
        echo "The following missing arguments are required:"
        echo
        echo "${missing_required_args[@]}"
        echo -e "${NO_COLOR}"
        print_usage
        exit 1
    fi
}

check_for_help "${@}"
validate_args "${@}"
