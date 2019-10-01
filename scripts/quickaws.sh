#!/usr/bin/env bash

saml2aws_profile="$1"
saml2aws_file="/home/$(whoami)/.saml2aws"
wait_count=10
cache_file="/home/$(whoami)/.quickaws-${saml2aws_profile}"
cache_present=0

fzf_colours="--color=fg:#888888,bg:-1,fg+:#FFFFFF,pointer:#01AB84,prompt:#01AB84,header:#01AB84,hl:#01AB84,hl+:#FFFFFF"

if [[ -z $1 ]]; then
    echo "!! Please pass a saml2aws profile as the first parameter. Exiting."
    exit 1
fi

if [[ -f "${saml2aws_file}" ]]; then
    saml2aws_profiles=$(cat "${saml2aws_file}" | egrep "^\[[a-z0-9]*\]$" | tr -d '[]')
else
    echo "!! saml2aws config file not found. Exiting."
    exit 1
fi

while read -r line; do
    if [[ "${line}" == "${saml2aws_profile}" ]]; then
        saml2aws_match=true
    fi
done <<< "${saml2aws_profiles}"

if [[ "${saml2aws_match}" == true ]]; then
    pass_password_path="clients/${saml2aws_profile}/ad"
    pass_otp_path="clients/${saml2aws_profile}/otp"

    if [[ -f "${cache_file}" ]]; then
        get_roles=$(cat "${cache_file}")
        cache_present=1
    else
        echo ":: Getting roles for profile \"${saml2aws_profile}\""
        get_roles=$(saml2aws list-roles \
            -a "${saml2aws_profile}" \
            --skip-prompt \
            --password=$(pass "${pass_password_path}") \
            --mfa-token=$(pass otp "${pass_otp_path}") \
            | grep "arn:aws:iam")
        echo "${get_roles}" > "${cache_file}"
    fi

    role_names=$(echo "${get_roles}" | awk -F'/' '{print $2}')

    chosen_role=$(echo "${role_names}" | fzf --reverse "${fzf_colours}" --margin=5%,25% --header="Select a role:")

    if [[ -z "${chosen_role}" ]]; then
        exit
    fi

    while read -r line; do
        if [[ "${line}" =~ "${chosen_role}" ]]; then
            if [[ "${cache_present}" == 0 ]]; then
                echo ":: Sleeping ${wait_count} seconds before assuming role..."
                sleep "${wait_count}"
            fi
            saml2aws login -a "${saml2aws_profile}" \
            --skip-prompt \
            --password=$(pass "${pass_password_path}") \
            --mfa-token=$(pass otp "${pass_otp_path}") \
            --role="${line}" \
            --force
        fi
    done <<< "${get_roles}"
else
    echo "!! saml2aws profile not found in config. Exiting."
    exit
fi
