#!/bin/bash

separator="%{F#404040}|%{F-}"
current_containers=$(docker ps --format '{{ .Names }}')
container_array=()

while read -r container; do
  case $container in
    "tokyo"*)
      container_array[1]="TOKYO"
      ;;
    "los-angeles"*)
      container_array[2]="LA"
      ;;
    "moscow"*)
      container_array[3]="MOSCOW"
      ;;
    "london"*)
      container_array[4]="LONDON"
      ;;
  esac
done <<< "${current_containers}"

if [[ "${#container_array[@]}" -gt 0 ]]; then
    echo "${container_array[@]} ${separator} "
else
    echo ""
fi
