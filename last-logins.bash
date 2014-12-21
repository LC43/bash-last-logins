#!/bin/bash

# Read the most recent logins

# Terminal colors
RESET="\e[0m"
BOLD="\e[1m"
RED="\e[31m"
YELLOW="\e[33m"

current_tty=`tty`;
current_day=`date +"%-d"`
yesterday=`date --date="yesterday" +"%-d"`
current_session=""


live_sessions=()
last_sessions=()
today_sessions=()
yesterday_sessions=()

while read session; do
#	read USER TTY EDAY_OR_HOST TIME <<< $(echo "$session" | awk '{ print $1, $2, $11, $14 }')
#	read USER TTY WEEKDAY MONTH DAY HOUR DIFFF EHOUR DURATION HOST <<< $(echo "$session" | awk '{ print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15 }')
	read USER TTY DAY EDAY_OR_HOST TIME <<< $(echo "$session" | awk '{ print $1, $2, $5 , $11, $14 }')
	if [[ "$HOST" == ":0" || "$HOST" == ":0.0" ]];then
		# Ignore "local" logins
		continue;
	elif grep -q "still logged in" <<<$session; then
		if [[ "/dev/$TTY" == "$current_tty" ]]; then
			current_session="$session"
		else
			live_sessions+=("$session")
		fi
	else
		dead_sessions+=("$session")
	fi


	if [[ "$DAY" == $current_day ]]; then
		today_sessions+=("$session")
	elif [[ "$DAY" == $yesterday ]]; then
		yesterday_sessions+=("$session")
 	fi
done < <(last -Fiwa $USER | head -n -2  )     # | tail -n +2 ) 

	# ----- LAST LOGIN

#read USER HOUR EHOUR DURATION HOST <<< $(echo "$yesterday_sessions" | awk '{ print $1, $6, $7, $9, $10 }')

#Echo -e "Yesterday, these where the connections made to this machine: "
#echo -e "$USER at $HOST logged in for $DURATION, from $HOUR to $EHOUR";

#read USER HOUR EHOUR DURATION HOST <<< $(echo "$today_sessions" | awk '{ print $1, $6, $7, $9, $10 }')

#echo -e "Yesterday, these where the connections made to this machine: "
#echo -e "$USER at $HOST logged in for $DURATION, from $HOUR to $EHOUR";

echo -e "\e[38;5;174mTODAY${RESET}, these where the connections made to this machine: "

if [ ${#today_sessions[@]} -gt 0 ]; then
  for today_session in "${today_sessions[@]}"
	do
		read USER TTY HOUR DASH_OR_STILL EDAY_OR_HOST EHOUR DURATION HOST <<< $(echo "$today_session" | awk '{ print $1, $2, $6, $8, $11, $12, $14, $15 }')
		if [[ "$DASH_OR_STILL" == "still" ]]; then
			HOST=$EDAY_OR_HOST
			EHOUR="and is \e[1;48;5;1mStill Logged In!${RESET}"
			LOGIN=$(echo "$today_session" | awk '{ print $4, $5, $7, $6 }')
			DURATION=`since "$LOGIN"`
			PERIOD=""
			ECHO_DURATION=""
			ECHO_PERIOD=$EHOUR
			if [[ "/dev/$TTY" == $current_tty ]]; then
				USER="YOU"
			fi

		else
			ECHO_PERIOD="from $HOUR to $EHOUR";
			ECHO_DURATION=" for "
		fi


#		printf "${BOLD}\e[38;5;205m$USER${RESET}at \e[38;5;38m$HOST${RESET} logged in $ECHO_DURATION \e[38;5;195m$DURATION${RESET}, $ECHO_PERIOD\n"
		printf "${BOLD}\e[38;5;205m%-10s${RESET} at \e[38;5;38m%s${RESET} logged in %s \e[38;5;195m%s${RESET}, $ECHO_PERIOD\n" "$USER" "$HOST" "$ECHO_DURATION" "$DURATION"
	done
fi


if [[ ${#yesterday_sessions[@]} -eq 0 ]]; then
	# ----- NO LOGINS YESTERDAY 
	echo -e "No logins were registered \e[38;5;174myesterday!${RESET}";
#	exit 0;
else 
 	echo -e "\e[38;5;174mYESTERDAY${RESET}, these where the connections made to this machine: "
  for yesterday_session in "${yesteday_sessions[@]}"
	do
		read USER HOUR EHOUR DURATION HOST <<< $(echo "$yesterday_session" | awk '{ print $1, $6, $7, $9, $10 }')
		echo -e "${BOLD}$USER${RESET} at ${BOLD}$HOST${RESET} logged in for ${BOLD}{RED}$DURATION${RESET}, from {YELLOW}$HOUR to $EHOUR${RESET}";
	done
fi


#	read USER TTY HOST TIME <<< $(echo "$session" | awk '{ print $1, $2, $3, $15 }')
#	read USER TTY EDAY_OR_HOST TIME <<< $(echo "$session" | awk '{ print $1, $2, $11, $14 }')
#	if [[ "$HOST" == ":0" || "$HOST" == ":0.0" ]];then
		# Ignore "local" logins
#		continue;
#	elif grep -q "still logged in" <<<$session; then
#		if [[ "/dev/$TTY" == "$current_tty" ]]; then
#			current_session="$session"
#		else
#			live_sessions+=("$session")
#		fi
#	else
#		dead_sessions+=("$session")
#	fi
  # recent logins  # junk data at end # Hide the current login
#done < <(last -Fiwa $USER | head -n -2 )     # | tail -n +2 ) 

if [ ${#live_sessions[@]} -gt 0 ]; then
	# ----- CURRENT LOGINS
  echo -e "You are also ${BOLD}${RED}still logged in${RESET} from the following machines:"
  for session in "${live_sessions[@]}"
	do
#		read USER TTY HOST TIME <<< $(echo "$session" | awk '{ print $1, $2, $3, $15 }')
		read TTY HOST TIME <<< $(echo "$session" | awk '{ print $2, $11 }')
		LOGIN=$(echo "$session" | awk '{ print $4, $5, $7, $6 }')

		since=`since "$LOGIN"`
		echo -e "  ${BOLD}*${RESET} Logged in ${BOLD}$since${RESET} from ${BOLD}\e[38;5;38m$HOST${RESET} on ${BOLD}${YELLOW}$TTY${RESET}";
	done
	
elif [[ ${#dead_sessions[@]} -eq 0 ]]; then
	# ----- NO CURRENT OR PREVIOUS LOGINS
	echo -e "Welcome, this is your ${BOLD}first time${RESET} logging in!";
	echo -e "If this is not your first time logging in, someone has tampered with the logs!";
	exit 0;
	
else
	# ----- LAST LOGIN
	last_session=${dead_sessions[0]}
#	read USER TTY HOST TIME <<< $(echo "$last_session" | awk '{ print $1, $2, $3, $15 }')
	read HOST <<< $(echo "$last_session" | awk '{ print $15 }')
 	LOGIN=$(echo "$last_session" | awk '{ print $5, $6, $8, $7 }')
	LOGOUT=$(echo "$last_session" | awk '{ print $10, $11, $13, $12 }')
	echo -e "Last logged in from ${BOLD}$LOGIN${RESET} to ${BOLD}$LOUGOUT${RESET} from ${BOLD}${YELLOW}$HOST${RESET}"
	
fi
