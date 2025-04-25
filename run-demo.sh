#!/usr/bin/env bash
set -e

# 1. Two cross-connected virtual serial ports
socat -d -d PTY,raw,echo=0,link=/tmp/vmodem0 \
               PTY,raw,echo=0,link=/tmp/vmodem1 &
SOCAT_PID=$!

# 2. Start the decoder on /tmp/vmodem1
python3 vedirect_mqtt.py --port /tmp/vmodem1 --mqttbroker mosquitto --mqttbrokerport 1883 --topicprefix vedirect/ &
READER_PID=$!

sleep 1   # give the reader a moment to open the port

# 3. Replay one of the bundled captures into /tmp/vmodem0
#    (awk adds a 1-second pause between frames so it feels like real hardware)
awk '/PID/{ } {print} /Checksum/{system("sleep 1")}' \
        test/smartsolar_1.39.dump > /tmp/vmodem0 &

wait $READER_PID            # keep container running until you Ctrl-C