#!/usr/bin/env bash

DISPLAY_RE="([0-9]+)x([0-9]+)\\+([0-9]+)\\+([0-9]+)"
IMAGE_RE="([0-9]+)x([0-9]+)"
LOCK="$HOME/dotfiles/lock/lock.png"
PARAMS=""
OUTPUT_IMAGE="/tmp/lockscreen.png"

# Delete old screenshot
rm $OUTPUT_IMAGE || true

# Take screenshot:
scrot -z $OUTPUT_IMAGE

# Get dimensions of the lock image:
LOCK_IMAGE_INFO=`identify $LOCK`
[[ $LOCK_IMAGE_INFO =~ $IMAGE_RE ]]
IMAGE_WIDTH=${BASH_REMATCH[1]}
IMAGE_HEIGHT=${BASH_REMATCH[2]}

# Execute xrandr to get information about the monitors:
while read LINE
do
  # If we are reading the line that contains the position information:
  if [[ $LINE =~ $DISPLAY_RE ]]; then
    # Extract information and append some parameters to the ones that will
    # be given to ImageMagick:
    WIDTH=${BASH_REMATCH[1]}
    HEIGHT=${BASH_REMATCH[2]}
    X=${BASH_REMATCH[3]}
    Y=${BASH_REMATCH[4]}
    POS_X=$(($X+$WIDTH/2-$IMAGE_WIDTH/2))
    POS_Y=$(($Y+$HEIGHT/2-$IMAGE_HEIGHT/2))

    PARAMS="$PARAMS $LOCK -geometry +$POS_X+$POS_Y -composite"
  fi
done <<<"`xrandr`"

# Execute ImageMagick:
convert $OUTPUT_IMAGE -scale 10% -scale 1000% $OUTPUT_IMAGE
convert $OUTPUT_IMAGE $PARAMS $OUTPUT_IMAGE

# Lock the screen:
i3lock -i $OUTPUT_IMAGE -t -e -f -d 1
