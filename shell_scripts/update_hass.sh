#!/bin/bash

VIRTUAL_ENV=/srv/homeassistant
HASS_SERVICE=home-assistant.service

# Create a backup
/etc/homeassistant/shell_scripts/backup_config.sh

# Activate virtualenv
source $VIRTUAL_ENV/bin/activate

# Upgrade Home Assistant
pip3 install --upgrade homeassistant

# Deactivate virtualenv
deactivate

# Restart Home Assistant
# This requires a modification using `sudo visudo`:
#   homeassistant ALL=(ALL) NOPASSWD: /bin/systemctl restart home-assistant.service
# Make sure to change `home-assistant.service` to the correct service name
sudo systemctl restart $HASS_SERVICE
