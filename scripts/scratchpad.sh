#!/usr/bin/env bash

# can extend this with params for multiple apps in scratchpads, good use for docker vpn

scratchpad_name="term-scratchpad"

if [[ $(pgrep -f "${scratchpad_name}") ]]; then
    i3 "[instance="${scratchpad_name}"] scratchpad show, move position center"
else
    i3 "exec --no-startup-id kitty --name ${scratchpad_name} --title ${scratchpad_name}"
    sleep .20
fi
