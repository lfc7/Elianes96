#! /bin/bash
SERIALPORT="/dev/ttyACM0"
#SERIALPORT="/dev/tty4"
#socat -d -d pty,raw,echo=0 pty,raw,echo=0

#socat -d -d pty,raw,echo=0 pty,raw,echo=0

stty -echo -F "$SERIALPORT" 2500000
./websocketd --port=8080 --staticdir=. ./WSpipe.sh
