#!/bin/bash

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') $(pactl --format=json list sinks | jq '.[] | select(.properties."alsa.card_name"=="FiiO K3") | .index')

pactl set-default-source $(pactl --format=json list sources | jq -r '.[] | select(.properties."alsa.card_name"=="Scarlett Solo 4th Gen") | .properties."node.name"')

exit 0
