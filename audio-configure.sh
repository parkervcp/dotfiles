#!/bin/bash

# get device names for alsa devices.
## defaults to first found USB or defaults to generic device
## get playback devices
echo -e "getting playback device"
if aplay -l | grep -q USB; then
    echo -e "USB playback device '$(aplay -l | grep -m 1 USB | awk '{ print $3 }')' found"
    output_dev=$(aplay -l | grep -m 1 USB | awk '{ print $3 }')
else
    echo -e "No usb playback devices found. Defaulting to Generic"
    output_dev=$(aplay -l | grep -i -m 1 generic | awk '{ print $3 }')
fi

## get recording devices
## defaults to first found USB or generic device
echo -e "getting recording device"
if arecord -l | grep -q USB; then
    echo -e "USB recording device '$(arecord -l | grep -m 1 USB | awk '{ print $3 }')' found"
    input_dev=$(arecord -l | grep -m 1 USB | awk '{ print $3 }')
else
    echo -e "No usb recording devices found. Defaulting to Generic"
    input_dev=$(arecord -l | grep -i -m 1 generic | awk '{ print $3 }')
fi

## restart pulse
echo -e "stopping pulse"
pulseaudio -k

echo -e "waiting 1 second"
sleep 1

echo -e "starting pulse"
pulseaudio --start

# configure and start jack
## print jack status
jack_control status

## set to use alsa
jack_control ds alsa
## set for the Schiit device
jack_control dps device hw:${output_dev}
## set the AT2020 USB mic
jack_control dps device hw:${input_dev}
## set rate
jack_control dps rate 48000
## set periods
jack_control dps nperiods 2

jack_control dps period 512
jack_control dps playback hw:${output_dev}
jack_control dps capture hw:${input_dev}
jack_control eps realtime true
jack_control start

echo -e "cleaning out old pulse sink devs"
## get all device ID's
SINKID=$(LANG=C pactl list | grep -B 1 "Name: module-jack-sink" | grep Module | sed 's/[^0-9]//g')
SOURCEID=$(LANG=C pactl list | grep -B 1 "Name: module-jack-source" | grep Module | sed 's/[^0-9]//g')

## loop device ID's and close them out
for i in $SINKID; do pactl unload-module ${i}; done
for i in $SOURCEID; do pactl unload-module ${i}; done

sleep 1

echo -e "setting up pulse audio sinks"
# add pulse audio sink
## output devices
pactl load-module module-jack-sink client_name=Desktop_OUTput
pactl load-module module-jack-sink client_name=Discord_OUTput
pactl load-module module-jack-sink client_name=Spotify_OUTput
## input devices
#pactl load-module module-jack-source client_name=Desktop_INput
pactl load-module module-jack-source client_name=Discord_INput
pactl load-module module-jack-source client_name=OBS_INput

# make audio connections