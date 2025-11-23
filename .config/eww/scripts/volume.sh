#!/usr/bin/bash

VOL_LEVEL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -1)
ICON=""

update_icon() {
    VOL_LEVEL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -1)
    if [[ $(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}') == 'no' ]]; then
       if (( VOL_LEVEL > 66 )); then
            ICON=""
        elif (( VOL_LEVEL > 33 )); then
            ICON=""
        elif (( VOL_LEVEL > 0 )); then
            ICON=""
        fi 
    else
        ICON=""
    fi
}


if [[ $1 == "get" ]]; then
    update_icon
    echo "{\"icon\": \"$ICON\", \"level\": \"$VOL_LEVEL\"}"
    pactl subscribe | grep --line-buffered "on sink" | while read -r _ ; do
        update_icon
        echo "{\"icon\": \"$ICON\", \"level\": \"$VOL_LEVEL\"}"
    done
elif [[ $1 == "set" ]]; then
    DELTA="$2"
    VOL_LEVEL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -1)
    if [[ $DELTA == +* ]]; then
        VOL=$((VOL_LEVEL + ${DELTA:1}))
    elif [[ $DELTA == -* ]]; then
        VOL=$((VOL_LEVEL - ${DELTA:1}))
    fi

    if (( VOL < 0 )); then
        VOL=0
    elif (( VOL > 100 )); then
        VOL=100
    fi
    pactl set-sink-volume @DEFAULT_SINK@ "${VOL}%"

elif [[ $1 == "toggle" ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
fi