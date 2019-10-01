#!/usr/bin/env bash

# gets all currently active users in a slack workspace that isn't a bot and outputs to csv in an alphabetical order

curl -s "https://slack.com/api/users.list?token=${SLACK_TOKEN}&pretty=1" | jq -r \
    '.members[] | select(.profile.email != null) | select(.deleted == false) | ([.name, .profile.real_name, .profile.email] | @csv)' | sort
