#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <logfile> [logfile...]"
  exit 1
fi

for LOGFILE in "$@"; do
  if [ ! -f "$LOGFILE" ]; then
    echo "Skipping: $LOGFILE not found"
    continue
  fi

  echo "===== $LOGFILE ====="
  echo "-- Log levels --"
  awk 'NF {print $3}' "$LOGFILE" | sort | uniq -c
  echo "-- Top errors --"
  grep ERROR "$LOGFILE" | cut -d' ' -f4- | sort | uniq -c | sort -rn
  echo
done
