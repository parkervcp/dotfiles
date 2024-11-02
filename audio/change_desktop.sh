#!/bin/bash

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') $(pactl --format=json list sinks | jq '.[] | select(.properties."alsa.card_name"=="FiiO USB DAC-E10") | .index')

exit 0
