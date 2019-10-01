#!/usr/bin/env bash

lockfile="/tmp/$(basename $0).lock"

if [[ -f "${lockfile}" ]]; then
    notify-send -i /home/id0827502/images/icons/password.png -t 5000 -u normal "Quickpass instance already open!"
    i3 "[instance="quickpass"] focus"
    exit 1
else
    echo $$ > "${lockfile}"
fi

trap "rm ${lockfile}" 0

fzf_colours="--color=fg:#888888,bg:-1,fg+:#FFFFFF,pointer:#01AB84,prompt:#01AB84,header:#01AB84,hl:#01AB84,hl+:#FFFFFF"
selected_pass=$(pass git ls-files '*.gpg' | sed 's/.gpg$//' | fzf --reverse "${fzf_colours}" --margin=5%,25% --header="Select a password:")
clipboard_expiry=45000

if [ -z "${selected_pass}" ]; then
    exit
else
    case "${selected_pass}" in
        *"otp"*)
            pass otp "${selected_pass}" | tr -d '\n' | xsel -bi -t "${clipboard_expiry}"
            ;;
        *)
            pass "${selected_pass}" | tr -d '\n' | xsel -bi -t "${clipboard_expiry}"
            ;;
    esac
fi
