#!/bin/bash
if [ $(hostname -s) != "aragorn" ]; then
    echo -e "This was not written for this host."
    exit 1
else
    echo -e "proceding with setting up jack for use on aragorn."
fi

# configure and start jack
## print jack status
jack_control status

## set to use alsa
jack_control ds alsa
## set for the Schiit device
jack_control dps device hw:S3
## set the AT2020 USB mic
jack_control dps device hw:USB
## set rate
jack_control dps rate 48000
## set periods
jack_control dps nperiods 3

jack_control dps period 128
jack_control dps capture hw:USB
jack_control dps playback hw:S3
jack_control eps realtime true
jack_control start

## get all device ID's
SINKID=$(LANG=C pactl list | grep -B 1 "Name: module-jack-sink" | grep Module | sed 's/[^0-9]//g')
SOURCEID=$(LANG=C pactl list | grep -B 1 "Name: module-jack-source" | grep Module | sed 's/[^0-9]//g')

## loop device ID's and close them out
for i in $SINKID; do pactl unload-module $i; done
for i in $SOURCEID; do pactl unload-module $i; done

sleep 1

## add devices to pactl
pactl load-module module-jack-sink client_name=Desktop_OUTput
pactl load-module module-jack-sink client_name=Discord_OUTput
pactl load-module module-jack-sink client_name=Spotify_OUTput
#pactl load-module module-jack-source client_name=Desktop_INput
pactl load-module module-jack-source client_name=Discord_INput
pactl load-module module-jack-source client_name=OBS_INput

# Audio input changes