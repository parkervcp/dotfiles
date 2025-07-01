#!/bin/bash

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') $(pactl --format=json list sinks | jq '.[] | select(.properties."alsa.card_name"=="CORSAIR VIRTUOSO MAX WIRELESS G") | .index')

#pactl set-default-source $(pactl --format=json list sources | jq -r '.[] | select(.properties."alsa.card_name"=="CORSAIR VIRTUOSO MAX WIRELESS G") | select (.properties."api.alsa.pcm.stream"=="capture") | .index')

exit 0
