#!/bin/bash

sudo mkdir /srv/hass/src/open-zwave-control-panel/.backup
sudo mv /srv/hass/src/open-zwave-control-panel/zw*.xml /srv/hass/src/open-zwave-control-panel/.backup
sudo ln -s /home/hass/.homeassistant/zw*.xml /srv/hass/src/open-zwave-control-panel/
