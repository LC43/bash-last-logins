#!/bin/bash

# Usage:
#   $ since "Jan 1, 2014"
#   $ since "12:45" "13:24"
#   $ since 'TZ="America/Los_Angeles" 09:00 next Fri'
#
# Arguments:
#   $1 - First time to compare
#   $2 - Second time to compare (optional, defaults to NOW)

# Convert the passed in date(s) to seconds since epoch
s1=$(date -d "$1" +%s);
if [[ -n "$2" ]]; then
	 s2=$(date -d "$2" +%s);
else
	# NOW
	s2=$(date +%s);
fi

s=$(( $s1 - $s2 ));

# Keep an absolute value of 's' 
if (( $s < 0 )); then
	 diff=$(( -$s ));
else
	diff=$(( $s ));
fi

function since_format(){
	# $1 - Numeric value of the time (e.g. 4)
	# $2 - Non-negative value of the time which will be printed (can also be a string, e.g. "four")
	# $3 - Time "type". Must be singular (e.g. "minute")
	if (( $1 == -1 )); then 
		echo "$2 $3 ago"
	elif (( $1 == 1 )); then
		echo "in $2 $3"
	elif (( $1 < 0 )); then
		echo "$2 $3s ago";
	else
		echo "in $2 $3s";
	fi
}

if (( $diff < 60 )); then
	 since_format $s $diff 'second'
elif (( $diff < 3600 )); then
		 since_format $(( $s / 60 )) $(( $diff / 60 )) 'minute'
elif (( $diff < 86400 )); then
		 since_format $(( $s / 3600 )) $(( $diff / 3600 )) 'hour'
else
	days=$(( $s / 86400 ))
	# Disabled, because if it is "Jan 1 at 12:00", then "Jan 3 at 11:00" will still return "tomorrow"
	#if (( $days == 1 )); then
	#		echo "tomorrow";
	#elif (( $days == -1 )); then
	#			echo "yesterday";
	#else
	since_format $days $(( $diff / 86400 )) 'day'
	#fi
fi

