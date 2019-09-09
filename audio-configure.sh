#!/bin/bash
if [ $(hostname -s) != "aragorn" ]; then
    echo -e "This was not written for this host."
    exit 1
else
    echo -e "proceding with setting up jack for use on aragorn."
fi

## get all device ID's
SINKID=$(LANG=C pactl list | grep -B 1 "Name: module-jack-sink" | grep Module | sed 's/[^0-9]//g')
SOURCEID=$(LANG=C pactl list | grep -B 1 "Name: module-jack-source" | grep Module | sed 's/[^0-9]//g')

# start non-mixer
if [ ! -z $(pgrep non-mixer) ]; then
    echo -e "killing current non-mixer setup"
    kill -s SIGTERM $(pgrep non-mixer)
    sleep 1
fi
non-mixer /home/parker/mixer/stream-mixer/ &

## loop device ID's and close them out
for i in $SINKID; do pactl unload-module $i; done
for i in $SOURCEID; do pactl unload-module $i; done

sleep 1

## add devices to pactl
pactl load-module module-jack-sink client_name=Desktop_OUTput
pactl load-module module-jack-sink client_name=Discord_OUTput
pactl load-module module-jack-sink client_name=Spotify_OUTput
#pactl load-module module-jack-source client_name=Special_INput
pactl load-module module-jack-source client_name=Discord_INput
pactl load-module module-jack-source client_name=OBS_INput


function connArray {
    array=$2
    for val in "${array[@]}"; do
        echo -e "$val"
        jack_disconnect $1 "$val"
    done
}

function discArray {
    array=$2
    for val in "${array}"; do
        jack_disconnect $1 "$val"
    done
}

# Audio input changes
# system capture_1
echo -e "configuring system capture_1"

echo -e "disconnecting all active sessions for system capture_1"
declare -a dsc_cap1=(Discord_INput:front-left OBS_INput:front-left)
for val in "${dsc_cap1[@]}"; do
    jack_disconnect system:capture_1 "$val"
done

echo -e "connecting system capture_1 to non-mixer inputs"
declare -a con_cap1=("Non-Mixer (mic):obs/in-1" "Non-Mixer (mic):discord-in/in-1")
for val in "${con_cap1[@]}"; do
    jack_connect system:capture_1 "$val"
done


# system capture_2
echo -e "configuring system capture_2"
declare -a dsc_cap2=(Discord_INput:front-right OBS_INput:front-right)
for val in "${dsc_cap2[@]}"; do
    jack_disconnect system:capture_2 "$val"
done

declare -a con_cap2=("Non-Mixer (mic):obs/in-2" "Non-Mixer (mic):discord-in/in-2")
for val in "${con_cap2[@]}"; do
    jack_connect system:capture_2 "$val"
done

#connect all inputs through non-mixer to their pulse outputs
jack_connect "Non-Mixer (mic):obs/out-1" Discord_INput:front-left
jack_connect "Non-Mixer (mic):obs/out-2" Discord_INput:front-right
jack_connect "Non-Mixer (mic):discord-in/out-1" OBS_INput:front-left
jack_connect "Non-Mixer (mic):discord-in/out-2" OBS_INput:front-right

# audio output changes
# system playback_1
echo -e "configuring system playback_1"
declare -a dsc_play1=(Desktop_OUTput:front-left Discord_OUTput:front-left Spotify_OUTput:front-left)
for val in "${dsc_play1[@]}"; do
    jack_disconnect system:playback_1 "$val"
done

declare -a con_play1=("Non-Mixer (headphones):desktop-out/out-1" "Non-Mixer (headphones):spotify-out/out-1" "Non-Mixer (headphones):discord-out/out-1")
for val in "${con_play1[@]}"; do
    jack_connect system:playback_1 "$val"
done

# system playback_2
echo -e "configuring system playback_2"
declare -a dsc_play2=(Desktop_OUTput:front-right Discord_OUTput:front-right Spotify_OUTput:front-right)
for val in "${dsc_play2[@]}"; do
    jack_disconnect system:playback_2 "$val"
done

declare -a con_play2=("Non-Mixer (headphones):desktop-out/out-2" "Non-Mixer (headphones):spotify-out/out-2" "Non-Mixer (headphones):discord-out/out-2")
for val in "${con_play2[@]}"; do
    jack_connect system:playback_2 "$val"
done

#connect all inputs through non-mixer to their pulse outputs
declare -a pulse_out=("Desktop_OUTput:front-left" "Discord_OUTput:front-left" "Spotify_OUTput:front-left")
declare -a non_headphone_in=("Non-Mixer (headphones):desktop-out/in-1" "Non-Mixer (headphones):discord-out/in-1" "Non-Mixer (headphones):spotify-out/in-1")
declare -i i=0

while [ "${pulse_out[i]}" -a "${non_headphone_in[i]}" ]; do
    echo -e "${pulse_out[i]} \"${non_headphone_in[i]}\""
    jack_connect ${pulse_out[i]} "${non_headphone_in[i]}"
    ((i++))
done

declare -a pulse_out=("Desktop_OUTput:front-right" "Discord_OUTput:front-right" "Spotify_OUTput:front-right")
declare -a non_headphone_out=("Non-Mixer (headphones):desktop-out/in-2" "Non-Mixer (headphones):discord-out/in-2" "Non-Mixer (headphones):spotify-out/in-2")
declare -i i=0

while [ "${pulse_out[i]}" -a "${non_headphone_out[i]}" ]; do
    echo -e "${pulse_out[i]} \"${non_headphone_out[i]}\""
    jack_connect ${pulse_out[i]} "${non_headphone_out[i]}"
    ((i++))
done