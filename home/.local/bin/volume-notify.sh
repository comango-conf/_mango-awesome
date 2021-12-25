#!/usr/bin/env bash

pactl subscribe | grep --line-buffered 'change.*sink #' | while read line ; do pamixer --get-volume-human | sed -e s/%// ; done ;
