#!/usr/bin/env bash

# Check for file modification in the last hour
if [[ -n "${DATA_DIR}" ]]; then
  FILE="${DATA_DIR}/.~last.json"
  AGE="$(( $(date --utc +%s) - $(stat --format=%Y "${FILE}") ))"
  if [[ ${AGE} -gt 3600 ]]; then
    echo "${FILE} age is ${AGE} seconds"
    exit 1
  fi
fi

# Check for scanning process
if pgrep -f --list-full scan_tuner.pl; then
  exit 0
else
  echo "scan_tuner.pl not running"
  exit 1
fi
