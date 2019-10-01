#!/usr/bin/env bash

# edit ~/.gnupg/gpg-agent.conf to change cache timeouts for passwords (86400 for a day)
# then reload the gpg-agent with: gpg-connect-agent reloadagent /bye
# todo: check to make sure getting roles was successful, set sane defaults, set timestamps

saml2aws_account="main"
saml2aws_sleep=5
saml2aws_retry_limit=3
role_grep_string="read"
pass_password_path="accounts/main"
pass_otp_path="accounts/main-otp"
line_count=0

COLOUR_GREEN='\e[0;32m'
COLOUR_RED='\e[0;31m'
COLOUR_NC='\e[0m'

if [[ -z "$*" ]]; then
    echo "Please set a command to run."
    exit
else
    command_name=$*
fi

echo ":: Obtaining list of available roles for account \"${saml2aws_account}\" with filter \"${role_grep_string}\"..."

saml2aws_roles=$(saml2aws list-roles -a "${saml2aws_account}" \
    --skip-prompt \
    --password=$(pass "${pass_password_path}") \
    --mfa-token=$(pass otp "${pass_otp_path}") \
    | grep "arn:aws:iam" | grep -i "${role_grep_string}")

echo "${saml2aws_roles}"

saml2aws_role_count=$(echo "${saml2aws_roles}" | wc -l)
echo ":: Total role count: ${saml2aws_role_count}"

echo ":: Waiting ${saml2aws_sleep} seconds before first role is assumed..."
sleep "${saml2aws_sleep}"

saml2aws_assume_role() {
    saml2aws login -a "${saml2aws_account}" \
        --skip-prompt \
        --password=$(pass "${pass_password_path}") \
        --mfa-token=$(pass otp "${pass_otp_path}") \
        --role="$1" > /dev/null
}

while read -r line; do
    retry_failed=0
    line_count=$(($line_count + 1))
    role_name=$(echo "${line}" | awk -F'/' '{print $2}')
    for i in $(seq 1 "${saml2aws_retry_limit}"); do
        echo ":: (${line_count}/${saml2aws_role_count}) Assuming role: ${line}..."
        saml2aws_assume_role "${line}" && break || \
        echo -e "${COLOUR_RED}!! Assuming role failed for role: ${line}${COLOUR_NC}"
        echo ":: Retrying: ${i} out of ${saml2aws_retry_limit} times"
        echo ":: Waiting ${saml2aws_sleep} seconds before trying again..."
        sleep "${saml2aws_sleep}"
        if [[ "${i}" == "${saml2aws_retry_limit}" ]]; then
            echo -e "${COLOUR_RED}!! SAML assertion failed for role: ${line}${COLOUR_NC}"
            echo -e "${COLOUR_RED}!! Check that your username, password, and MFA token are correct, not expired, and work manually before trying again.${COLOUR_NC}"
            echo -e "${COLOUR_RED}!! Command: saml2aws login -a ${saml2aws_account} --role=${line}${COLOUR_NC}"
            retry_failed=1
        fi
    done
    if [[ "${retry_failed}" == 0 ]]; then
        echo -e "${COLOUR_GREEN}>> Role assumed: ${line}${COLOUR_NC}"
        echo ":: Executing command: ${command_name}"
        # command goes here
        $command_name > "${role_name}".txt
        if [[ $? == 0 ]]; then
            echo -e "${COLOUR_GREEN}>> Command completed successfully: ${command_name}${COLOUR_NC}"
        else
            echo -e "${COLOUR_RED}!! Command exited with non-zero error code: ${command_name}${COLOUR_NC}"
        fi
    else
        retry_failed=0
    fi
    if [[ "${line_count}" == "${saml2aws_role_count}" ]]; then
        echo ":: Script complete"
    else
        echo ":: Waiting ${saml2aws_sleep} seconds before next role is assumed..."
        sleep "${saml2aws_sleep}"
    fi
done <<< "${saml2aws_roles}"

notify-send -i /home/id0827502/pictures/icons/sso.png -t 5000 -u normal "saml2aws-auto" "\nScript run complete."
