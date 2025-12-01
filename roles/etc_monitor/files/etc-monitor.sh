#!/bin/sh

# Purpose: monitor file changes under /etc and send emails to root.
# Usage: sh path/to/etc-monitor.sh
# Dependencies: inotifywait, sendmail
#   - Install "inotify-tools" to make the "inotifywait" command available.
#   - Install "bsd-mailx" to make the "sendmail" command available.
# Date: 2025-11-27
# Author: Yusong

set -e

log_file="/var/log/etc-monitor.log"
mkdir -p "$(dirname "$log_file")"

inotifywait -mr --format '%w%f %e' \
  --event modify,create,delete,move \
  /etc | while read -r file event; do

  timestamp=$(date --rfc-3339=seconds)
  # Append to log_file and output to stdout.
  echo "$timestamp - $event - $file" | tee -a "$log_file"
  # Send an email to root.
  {
    echo "Subject: /etc change detected - $event - $file"
    echo ""
    echo "Timestamp: $timestamp"
    echo "Event: $event"
    echo "File: $file"
  } | sendmail root

done
