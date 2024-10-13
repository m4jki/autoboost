#!/bin/bash

# Location of configuration file
CONFIG_FILE="/etc/autoboost.cfg"

# Reading config variables

TURBO_OFF_TEMP=$(cat "$CONFIG_FILE" | grep OFF | cut -d'=' -f2)
TURBO_ON_TEMP=$(cat "$CONFIG_FILE" | grep ON | cut -d'=' -f2)

# Checking if config file exist
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file $CONFIG_FILE not found!"
  exit 1
fi

# File that controls Turbo Boost
TURBO_FILE="/sys/devices/system/cpu/intel_pstate/no_turbo"

# Check if the file exists
if [ ! -f "$TURBO_FILE" ]; then
    echo "Turbo Boost control file not found!"
    exit 1
fi

while true; do
  # Getting the CPU temperature in Celsius.
  temp=$(sensors | grep "Core 0" | awk '{print $3}' | awk '{print substr($0, 2, 2)}')
  CURRENT_STATE=$(cat $TURBO_FILE)

# Toggle the state
if [ "$temp" -ge "$TURBO_OFF_TEMP" ] && [ "$CURRENT_STATE" -eq "0" ]; then
    echo 1 | sudo tee $TURBO_FILE > /dev/null
fi 

if [ "$temp" -le "$TURBO_ON_TEMP" ] && [ "$CURRENT_STATE" -eq "1" ]; then
    echo 0 | sudo tee $TURBO_FILE > /dev/null
fi

sleep 1
done
