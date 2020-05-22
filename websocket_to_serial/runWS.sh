#! /bin/bash
SERIALPORT="/dev/ttyACM0"
#SERIALPORT="/dev/tty4"
#socat -d -d pty,raw,echo=0 pty,raw,echo=0

#socat -d -d pty,raw,echo=0 pty,raw,echo=0

#create WSpipe.sh
cat > WSpipe.sh << "EOF"
#! /bin/bash 

SERIALPORT="/dev/ttyACM0"
PIPEFILEprefix="/tmp/webSocketPipe"

timestamp=$(date +%s)
PIPEFILE="${PIPEFILEprefix}${timestamp}"

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
		while read -r -s line 
		do
			echo "$line" > "$PIPEFILE"
			#echo "$line" >> "logSerial2Ws.log"
		done < "$SERIALPORT"

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

	while read -r -s command
	do
		echo "$command" | buffer > "$SERIALPORT" #a renvoyer vers Serial
		#echo "$command" >> "logWs2Serial.log"
		done
done
EOF

#make wfmu_replay_chgplay.sh executable
chmod u+x WSpipe.sh

function cleanWS {
	rm	"WSpipe.sh"
}

trap cleanWS EXIT

stty -echo -F "$SERIALPORT" 2500000
./websocketd --port=8080 --staticdir=. ./WSpipe.sh
