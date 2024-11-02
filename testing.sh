# fs quota testing
/dev/sdc on /mnt/xfs type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,prjquota)
/dev/sdb on /mnt/ext type ext4 (rw,relatime)

zfs create tank/home/jeff -o mountpoint /
zfs set quota=10G tank/home/jeff


# pipewire control
pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K3-00.analog-stereo


pactl --format=json list sinks | jq '.[]'


pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') $(pactl --format=json list sinks | jq '.[] | select(.properties."alsa.card_name"=="FiiO K3") | .index')

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') $(pactl --format=json list sinks | jq '.[] | select(.properties."alsa.card_name"=="FiiO USB DAC-E10") | .index')

pactl move-sink-input $(pactl --format=json list sink-inputs | jq '.[] | select(.properties."node.name"=="playback.middleman") | .index') $(pactl --format=json list sinks | jq '.[] | select(.properties."alsa.card_name"=="Audeze Maxwell Dongle") | .index')


echo -e "Would you like get all available sound cards [Y/n]"

pactl --format=json list sinks | jq '.[] | .properties."alsa.card_name" | select(.)'


pactl --format=json list sources | jq '.[] | select(.properties."alsa.card_name"=="Audeze Maxwell Dongle")'