#!bin_bash
dnf install jack-audio-connection-kit jack-audio-connection-kit-dbus jack-audio-connection-kit-devel jack-audio-connection-kit-example-clients jack_capture pulseaudio-module-jack

usermod -aG jackuser $(whoami)