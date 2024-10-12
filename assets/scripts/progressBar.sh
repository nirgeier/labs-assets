#!/bin/bash

# Reset
NO_COLOR='\033[0m'       # Text Reset

BAR_WIDTH=50
CHAR_COMPLETE="#"
CHAR_REMAIN="-"

# Get the start time of the script
TIME_START=$(date +%s)
TIME_RUNNING=$(date +%s)
TIME_OVERALL=$(date +%s)
TIME_REMAIN=$(date +%s)

# Steps to complete in the script
STEPS_TOTAL=100
STEPS_COMPLETED=0
STEPS_REMAIN=100

################################################################
# Function to show progress
# $1 : complete progress
# $2 : total progress
################################################################
function show_progress {
    
    # Get the complete progress values
    STEPS_COMPLETED="$1"
    STEPS_TOTAL="$2"

    # Update the progress timers
    update_time_stamp $percent
    
    ### Calculate the progress 
    ### `bc` - command for command line calculator.
    ### scale ( expression )
    ### The value of the scale function is the number of digits after the decimal point in the expression.
    local percent=$(bc <<< "scale=0; 100 * $STEPS_COMPLETED / $STEPS_TOTAL" )

    # Calculate done & remain values
    local done=$(bc <<< "scale=0; $BAR_WIDTH * $percent / 100" )
    local todo=$(bc <<< "scale=0; $BAR_WIDTH - $done" )

    # Generate the complete & ramain sections
    local compelted=$(printf "%${done}s" | tr " " "${CHAR_COMPLETE}")
    local remaining=$(printf "%${todo}s" | tr " " "${CHAR_REMAIN}")

    # Calculate color values and print the progress bar
    echo -en "\r$(set_color $percent "[${compelted}${remaining}]")${NO_COLOR} ${percent}% $(convert_seconds_to_time $TIME_LEFT)  "
    
    # Check for completion
    if [ $STEPS_TOTAL -eq $STEPS_COMPLETED ]; then
        echo -e "\nDONE"
    fi
}

################################################################
## Function to update the time stamp
## 
##   stepTime     = TIME_RUNNING  / STEPS_COMPLETED
##   TIME_OVERALL = stepTime      * STEPS_TOTAL
##   TIME_REMAIN  = TIME_OVERALL  - TIME_RUNNING
################################################################
function update_time_stamp(){

  # Get the current time in seconds and calculate the time elapsed
  TIME_RUNNING=$(bc <<< "$(date +%s)-$TIME_START")

  # Calculate single step avarage time
  stepTime=$(bc <<< "scale=3; $TIME_RUNNING/$STEPS_COMPLETED" )
  
  # Calculate the required time
  TIME_OVERALL=$(bc <<< "scale=0; ($stepTime*$STEPS_TOTAL) / 1" )
    
  TIME_LEFT=$(bc <<< "scale=0; ($TIME_OVERALL-$TIME_RUNNING) / 1")
}

################################################################
# Function to set the color scale form red to green
## $1 : completed progress
## $2 : message to display
## Returns the color scale value as a string for the echo command.
## 
## Example: set_color 50 "This is 50% completed"
################################################################
function set_color() {

  local completed=$1
  local message=$2
  local R G B

  # Calculate color values
  R=$(( 255 - $(( $completed*255/100)) ))
  G=$(( 255 - $R ))
  B=0

  # Print the number with its calculated color
  printf "\e[38;2;%d;%d;%dm%s\e[0m\n" $R $G $B "$message"
}

################################################################
# Function to convert seconds to full time
## $1 : number of seconds
## Returns the full time of given seconds
################################################################
function convert_seconds_to_time() {
  local seconds=$1
  printf "%02d:%02d:%02d" $((seconds/3600)) $(((seconds%3600)/60)) $((seconds%60))
}

