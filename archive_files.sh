#!/bin/bash
# $Revision:001$
# $Thursday 04 July 2024 01:20:01 PM IST$

# Variables
BASE="/home/student/ak"
DAYS=10
DEPTH=1
RUN=0
LOG_FILE="/var/log/archive_script.log"

# Function to log messages
log_message() {
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

# Check if the directory is present or not
if [ ! -d "$BASE" ]; then
    log_message "Directory does not exist: $BASE"
    exit 1
fi

# Create 'archive' folder if not present
if [ ! -d "$BASE/archive" ]; then
    mkdir "$BASE/archive"
    log_message "Created archive folder: $BASE/archive"
fi

# Find the list of files larger than 20MB and archive them
find "$BASE" -maxdepth "$DEPTH" -type f -size +20M | while read -r i; do
    if [ $RUN -eq 0 ]; then
        log_message "Archiving $i ==> $BASE/archive"
        gzip "$i" || log_message "Failed to gzip $i"
        mv "$i.gz" "$BASE/archive" || log_message "Failed to move $i.gz to $BASE/archive"
    fi
done

log_message "Script execution completed."

