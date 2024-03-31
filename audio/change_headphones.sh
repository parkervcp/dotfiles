#!/bin/bash

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K3-00.analog-stereo

exit 0