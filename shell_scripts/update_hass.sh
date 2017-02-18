#!/bin/bash

# Create a backup
/etc/homeassistant/shell_scripts/backup_config.sh pre_update

# Activate virtualenv
source /srv/homeassistant/bin/activate

# Upgrade Home Assistant
pip3 install --upgrade homeassistant

# Deactivate virtualenv
deactivate

# Restart Home Assistant
# This requires a modification using `sudo visudo`:
#   homeassistant ALL=(ALL) NOPASSWD: /bin/systemctl restart home-assistant.service
sudo systemctl restart home-assistant.service
