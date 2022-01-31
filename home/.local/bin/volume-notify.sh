#!/usr/bin/env bash


function printStats() {
    sink=$(pamixer --get-default-sink | awk -vFPAT='([^ ]*)|("[^"]+")' '{if(NR>1)print $3}')
    volume=$(pamixer --get-volume)
    muted=$(pamixer --get-mute)

    printf "%s\t%s\t%s\n" "$sink" $volume $muted
}


printStats
pactl subscribe | grep --line-buffered 'change.*sink #' | while read line ; do printStats ; done ;
