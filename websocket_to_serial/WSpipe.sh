#! /bin/bash 

#SERIALPORT="/dev/ttyAMA0"
#SERIALPORT="/dev/pts/4"
SERIALPORT="/dev/ttyACM0"

timestamp=$(date +%s)
PIPEFILE="/tmp/webSocketPipe${timestamp}"

mkfifo "$PIPEFILE" >/dev/null 2>&1

function finish {
    echo "catpipe exit"
}

function cleanEnv {
	
    kill -SIGKILL "$PIDpipe"
    kill -SIGKILL "$PIDserial"
	rm	"$PIPEFILE"
 
}

function catpipe()
{
	trap finish EXIT
	while true ;
	do 
		tail -n +1 -f "$PIPEFILE" 
	done
}

### receive from serial to websocket
function catserial()
{
	trap finish EXIT
	while true ;
	do 
		#while read -t 0 notused
		#do
			while read -r -s line 
			do
				echo "$line" > "$PIPEFILE"
				#echo "$line" >> "logSerial2Ws.log"
			done < "$SERIALPORT"
		#done
	done
}
# main *****************************************************************
# : > "logSerial2Ws.log"
# : > "logWs2Serial.log"

### maintain pipe open
catpipe &
PIDpipe=$!

### receive from serial to websocket
catserial &
PIDserial=$!

trap cleanEnv EXIT

while true ;
do 
	### send from websocket to serial
	#while read -t 0 notused
	#do
		while read -r -s command
		do
			echo "$command" | buffer > "$SERIALPORT" #a renvoyer vers Serial
			#echo "$command" >> "logWs2Serial.log"
		done
	#done
done


#./catpipe &

