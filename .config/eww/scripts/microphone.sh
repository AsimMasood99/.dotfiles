#!/usr/bin/env bash

# Get current mic volume
VOL_LEVEL=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]+(?=%)' | head -1)
ICON=""

update_icon() {
    VOL_LEVEL=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]+(?=%)' | head -1)
    if [[ $(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}') == 'no' ]]; then
        ICON=""       
    else
        ICON=""
    fi
}

if [[ $1 == "get" ]]; then
    update_icon
    echo "{\"icon\": \"$ICON\", \"level\": \"$VOL_LEVEL\"}"
    pactl subscribe | grep --line-buffered "on source" | while read -r _ ; do
        update_icon
        echo "{\"icon\": \"$ICON\", \"level\": \"$VOL_LEVEL\"}"
    done

elif [[ $1 == "set" ]]; then
    DELTA="$2"
    VOL_LEVEL=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -Po '[0-9]+(?=%)' | head -1)
    if [[ $DELTA == +* ]]; then
        VOL=$((VOL_LEVEL + ${DELTA:1}))
    elif [[ $DELTA == -* ]]; then
        VOL=$((VOL_LEVEL - ${DELTA:1}))
    fi

    # Clamp 0–100
    if (( VOL < 0 )); then VOL=0; fi
    if (( VOL > 100 )); then VOL=100; fi

    pactl set-source-volume @DEFAULT_SOURCE@ "${VOL}%"

elif [[ $1 == "toggle" ]]; then
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
fi
