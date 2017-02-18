#!/bin/bash

CONFIG_DIR=/etc/homeassistant
BACKUP_FILE=/srv/homeassistant/backup/homeassistant_$(date +"%Y%m%d_%H%M").zip

pushd $CONFIG_DIR >/dev/null
zip -9 -q -r $BACKUP_FILE . -x"components/*" -x"deps/*" -x"home-assistant.db" -x"home-assistant_v2.db" -x"home-assistant.log"
popd >/dev/null

echo Backup complete: $BACKUP_FILE
