#!/bin/bash
DIR=$1

if [ ! -d "$DIR" ]; then
	echo "Scource Dir Not found"
	exit 1
fi

BACKUP="./backups"

NAME="backup-$(date +%Y-%m-%d-%H%M).tar.gz"

tar -czf "$BACKUP/$NAME" "$DIR"

LOG="./logs/backup.log"
echo "[$(date) SUCCESS: archived $DIR -> $NAME]" >> "$LOG"


find "$BACKUP" -name "*.tar.gz" -mtime +7 -delete
