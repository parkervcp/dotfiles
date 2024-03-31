#!/bin/bash

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') alsa_output.usb-Audeze_LLC_Audeze_Maxwell_Dongle_0000000000000000-01.analog-stereo

exit 0