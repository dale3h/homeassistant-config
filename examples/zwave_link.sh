#!/bin/bash

OZWCP_PATH=/srv/hass/src/open-zwave-control-panel
HASS_PATH=/home/hass/.homeassistant

sudo mkdir $OZWCP_PATH/.backup
sudo mv $OZWCP_PATH/zw*.xml $OZWCP_PATH/.backup
sudo ln -s $HASS_PATH/zw*.xml $OZWCP_PATH/
