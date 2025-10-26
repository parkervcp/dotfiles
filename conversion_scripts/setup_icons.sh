#!/bin/bash

BASEFOLDER=$(pwd)

convert_images () {
    find -type f -name '*.svg' -exec sh -c 'file="{}"; rsvg-convert -a -w 1024 -f svg "$file" -o "$file"' \;
    find -type f -name '*.svg' -exec sh -c 'file="{}"; convert -size 1024x1024 "$file" -define png:color-type=2 $( [ "$INVERSE" == "0" ] || printf %s '-negate' ) "${file%.svg}.png"' \;
} 

## download the RemixIcons and simple-icons repo and convert from svg to png
## will convert all svgs in a folder and subfolders into pngs
## pngs will have transparent backgrounds.

## pass -i to invert colors to get white icons vs the default black
INVERSE=1

if [ "$1" != "-i" ]; then
  INVERSE=0;
fi

cd ${BASEFOLDER}/RemixIcon/icons
convert_images

cd ${BASEFOLDER}/simple-icons/icons/
convert_images
