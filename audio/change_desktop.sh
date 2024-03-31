#!/bin/bash

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_USB_DAC-E10-00.analog-stereo

exit 0