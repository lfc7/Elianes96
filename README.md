# html-DMX-lighting-desk-96-24-8
html &amp; javascript lighting desk 96 circuits, 24 memories, 8 chasers

A lighing desk for browser linked thru usbSerial to my teensy DMX dongle. 

You need to download "websocketd" adapt to your system : http://websocketd.com/ . 
Copy "websocketd" in "runWS.sh" & "WSpipe.sh" folder.
dependency: buffer ( sudo apt install buffer )

run "runWS.sh" to start link between websocketd and serial "/dev/ttyACM0"
