#! /bin/sh

# Store fan curve and temp key value pairs in an associative array
# that will be used to control the fan speed
declare -A FANCURVE=( [40]=33 [50]=44 [60]=55 [65]=66 [70]=77 [80]=88 [85]=95 [MAX]=100 )

echo "This script will adjust the fan speed of the nvidia gpu
according to the fan curve defined in this script.\n"

# Get the temperature and write to a file without appending
log_temp () {
    nvidia-smi -q -d TEMPERATURE | grep "GPU Current Temp" | tee /tmp/nvfancontrol.temps.log &>/dev/null
    sleep 1
}

# Enable setting fan speed
nvidia-settings -c :0 -a "[gpu:0]/GPUFanControlState=1" 


# Allow a moment for the log files to be created and written to before trying to access them
sleep 2


# Function to set new fan speed
adjust_fan_speed () {
 nvidia-settings  -c :0 -a "[fan:0]/GPUTargetFanSpeed=$1"
 echo "Fan speed set to $1"
}

# get information from logs if available
get_temp () {
    if [ -s /tmp/nvfancontrol.temps.log ]
    then
        gpu_temp=$( cut -c 45-46 /tmp/nvfancontrol.temps.log )
    fi
## If the script is not working enable the echo GPU Temp statement below for debugging
## Verify there is a two digit integer being pulled as the temperature in the above cut command, adjust characters
## that are being pulled as necessary.

    #echo "GPU Temp: $gpu_temp"
}


# Function to get temp and adjust the fan speed up or down if necessary
monitor_temps_and_adjust_fans () {
    log_temp

    get_temp

    # declare -A FANCURVE=( [40]=33 [50]=44 [60]=55 [65]=66 [70]=77 [80]=88 [90]=100 )

    if [ $gpu_temp -le 40 ]
    then
        adjust_fan_speed ${FANCURVE[40]}
    elif [[ $gpu_temp -gt 40 && $gpu_temp -le 50 ]]
    then
        adjust_fan_speed ${FANCURVE[50]}
    elif [[ $gpu_temp -gt 50 && $gpu_temp -le 60 ]]
    then
        adjust_fan_speed ${FANCURVE[60]}
    elif [[ $gpu_temp -gt 60 && $gpu_temp -le 65 ]]
    then
        adjust_fan_speed ${FANCURVE[65]}
    elif [[ $gpu_temp -gt 65 && $gpu_temp -le 70 ]]
    then
        adjust_fan_speed ${FANCURVE[70]}
    elif [[ $gpu_temp -gt 70 && $gpu_temp -le 80 ]]
    then
        adjust_fan_speed ${FANCURVE[70]}
    elif [[ $gpu_temp -gt 80 && $gpu_temp -le 85 ]]
    then
        adjust_fan_speed ${FANCURVE[85]}
    elif [[ $gpu_temp -gt 85 ]]
    then
        adjust_fan_speed ${FANCURVE[MAX]}
    fi

}



# Run the monitor_temps_and_adjust_fans function on an infinite loop.
while :
do
    monitor_temps_and_adjust_fans
done

# Catch ctrl+c signal
trap control_c SIGINT

control_c ()
{
    
    exit 2
}
