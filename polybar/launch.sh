#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar top -c $HOME/.config/polybar/config.ini & 
polybar bottom -c $HOME/.config/polybar/config.ini &  

echo "Bars launched..."
