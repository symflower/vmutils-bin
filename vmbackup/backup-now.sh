#!/bin/bash

SNAPSHOT_CREATE_URL=${SNAPSHOT_CREATE_URL:-"http://$(hostname):8482/snapshot/create"}
DST_URL=${DST_URL:-"fs:///vm-backup/$(hostname)/"}
STORAGE_PATH=${STORAGE_PATH:-"/vm-data"}
BACKOFF_TIME=${BACKOFF_TIME:-"10m"}
MAX_TRIES=${MAX_TRIES:-5}

echo "${SNAPSHOT_CREATE_URL}"
echo "${DST_URL}"
echo "${STORAGE_PATH}"
echo "${BACKOFF_TIME}"
echo "${MAX_TRIES}"

while ! /vmbackup-prod -storageDataPath="${STORAGE_PATH}" -snapshot.createURL="${SNAPSHOT_CREATE_URL}" -dst="${DST_URL}"; do
  MAX_TRIES=$(( MAX_TRIES - 1 ))
  if [ "$MAX_TRIES" -eq 0 ]; then
    echo "Victoria metrics backup didn't succeed! Exiting." >&2
    exit 1
  fi

  sleep "$BACKOFF_TIME" || break
done
