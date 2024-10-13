#!/bin/bash

# Set the shutdown threshold temperature for Turbo.
TURBO_OFF_TEMP=60

# Set the threshold temperature for Turbo to turn on.
TURBO_ON_TEMP=50

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
