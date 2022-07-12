#!/bin/bash
if [ -f /etc/redhat-release ]; then
    echo -e "working on a redhat based system."
    if cat /etc/redhat-release | grep -i -q fedora; then
        echo -e "installing jack audio connection kit"
        sudo dnf install jack-audio-connection-kit jack-audio-connection-kit-dbus jack-audio-connection-kit-devel jack-audio-connection-kit-example-clients jack_capture pulseaudio-module-jack python2-dbus
        echo -e "adding current user to the 'jackuser' group."
        echo -e "you will need to log out and in to load this properly."
        sudo usermod -aG jackuser $(whoami)
    fi
elif [ -f /etc/arch-release ]; then
    echo -e "working on an arch based system."
fi
