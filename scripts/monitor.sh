#!/bin/bash

LOG="./logs/alert.log"

DISK_THRESHOLD=80
MEM_THRESHOLD=500
LOAD_THRESHOLD=2.0
PROCESS_THRESHOLD=200

DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
MEM=$(free -m | awk '/Mem:/ {print $7}')
LOAD=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | xargs)
PROCESS=$(ps aux | wc -l)
alert=0

if [ $DISK -gt $DISK_THRESHOLD ]; then
	echo "$(date '+%Y-%m-%d %H:%M:%S') ALERT: disk usage is at ${DISK}%, threshold is ${DISK_THRESHOLD}" >> "$LOG"
	alert=1
fi

if [ $MEM -lt $MEM_THRESHOLD ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') ALERT: memory usage is at ${MEM} MB, threshold is ${MEM_THRESHOLD}" >> "$LOG"
	alert=1
fi

if (( $(echo "$LOAD > $LOAD_THRESHOLD" | bc -l) )); then
        echo "$(date '+%Y-%m-%d %H:%M:%S') ALERT: LOAD usage is at ${LOAD} , threshold is ${LOAD_THRESHOLD}" >> "$LOG"
	alert=1
fi

if [ $PROCESS -gt $PROCESS_THRESHOLD ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') ALERT: Process usage is at ${PROCESS} , threshold is ${PROCESS_THRESHOLD}" >> "$LOG"
fi

if [ $alert -eq 0 ]; then
	echo "$(date '+%Y-%m-%d %H:%M:%S') OK: All metrics within thresholds" >> "$LOG"
fi
