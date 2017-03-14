#!/bin/bash

# Path variables
HASS_SERVICE=${HASS_SERVICE:-home-assistant.service}
HASS_CONFIG=${HASS_CONFIG:-/etc/homeassistant}
VIRTUAL_ENV=${VIRTUAL_ENV:-/srv/homeassistant}

# This is for log purposes
echo
echo "[$(date)] Update script starting"

# Show package information
$VIRTUAL_ENV/bin/pip3 search homeassistant

# Run the backup script
$HASS_CONFIG/shell_scripts/backup_config.sh

# Upgrade Home Assistant
$VIRTUAL_ENV/bin/pip3 install --upgrade homeassistant

# Restart Home Assistant
# This requires a modification using `sudo visudo`:
#   homeassistant ALL=(ALL) NOPASSWD: /bin/systemctl restart home-assistant.service
# Make sure to change `home-assistant.service` to the correct service name
sudo systemctl restart $HASS_SERVICE
