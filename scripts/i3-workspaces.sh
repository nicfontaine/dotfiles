#!/usr/bin/env bash

function i3_workspaces() {
    get_workspaces=$(i3-msg -t get_workspaces)

    workspace_count=$(echo "${get_workspaces}" | jq '. | length')

    for i in $(seq $workspace_count); do
        json_index=$(expr "${i}" - 1)
        if [[ $(echo "${get_workspaces}" | jq ".[$json_index].focused") == true ]]; then
            echo -n "FOCUSED"
        else
            echo -n "UNFOCUSED"
        fi
        echo -n $(echo "${get_workspaces}" | jq -r ".[$json_index].name")
        echo -n " "
    done
}


while true; do
    i3_workspaces
    sleep .5
done
