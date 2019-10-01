#!/usr/bin/env bash

mode="$1"

save_path="/home/id0827502/images/screenshots/"

msg_snippet_title="Screenshot snippet taken!"
msg_full_title="Screenshot taken!"
msg_content="Saved to ${save_path}"

case "${mode}" in
  --snippet|-s)
    maim -su "${save_path}"screenshot-snippet-$(date "+%Y-%m-%dT%H_%M_%S").png && \
    notify-send -i /home/id0827502/images/icons/screenshot.png -t 5000 -u normal "${msg_snippet_title}" "${msg_content}"
    ;;
  --full|-f)
    maim -u "${save_path}"screenshot-$(date "+%Y-%m-%dT%H_%M_%S").png && \
    notify-send -i /home/id0827502/images/icons/screenshot.png -t 5000 -u normal "${msg_full_title}" "${msg_content}"
    ;;
  *)
    echo "Invalid option. Exiting"
    ;;
esac
