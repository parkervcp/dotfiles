#!/bin/bash

pgrep obs || /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=obs com.obsproject.Studio & disown

exit 0
