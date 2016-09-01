#!/bin/bash

# Run backup first
/home/pi/shell/backup_config.sh

# Run update
pushd /home/pi >/dev/null
sudo pip3 install --upgrade homeassistant
hassctl restart
popd >/dev/null
