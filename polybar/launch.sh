#!/usr/bin/env bash

# terminate already running bar instances
killall -q polybar
# if all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar base -c ~/.config/polybar/config.ini &
echo "Bars launched..."
