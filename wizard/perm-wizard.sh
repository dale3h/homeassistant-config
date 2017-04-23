#!/bin/bash

# Install by running:
# wget -Nnv https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/perm-wizard.sh && sudo bash perm-wizard.sh

echo "Home Assistant Config Permissions Wizard"
echo "Copyright(c) 2017 Dale Higgs <@dale3h>"
echo

if [[ $UID != 0 ]]; then
  echo "Please run this script with sudo:"
  echo "  sudo $0 $*"
  exit 1
fi

HASS_CONFIG="${HASS_CONFIG:-/home/homeassistant/.homeassistant}"
HASS_USER="${HASS_USER:-homeassistant}"
HASS_GROUP="${HASS_GROUP:-$HASS_USER}"

read -e -i "$HASS_CONFIG" -p "Enter your Home Assistant config directory: " HASS_CONFIG
if [[ ! -d "$HASS_CONFIG" ]]; then
  echo "$HASS_CONFIG: no such directory"
  exit 1
fi

read -e -i "$HASS_USER" -p "Enter your Home Assistant user: " HASS_USER
if [[ $(id -u "$HASS_USER" 2>&1 >/dev/null) ]]; then
  echo "$HASS_USER: no such user"
  exit 1
fi

read -e -i "$HASS_GROUP" -p "Enter your Home Assistant group: " HASS_GROUP
if [[ ! $(getent group $HASS_GROUP) ]]; then
  echo "$HASS_GROUP: no such group"
  exit 1
fi

ME="$(/usr/bin/logname)"

echo
echo "Adding user to '$HASS_GROUP' group"
usermod -G $HASS_GROUP $ME

echo "Setting group to '$HASS_GROUP'"
chown -R $HASS_USER:$HASS_GROUP "$HASS_CONFIG"

echo "Adding sticky bit"
find "$HASS_CONFIG" -type d -exec chmod g+s {} \;

echo "Removing public permissions"
chmod -R o-rwx "$HASS_CONFIG"

echo "Setting default facl mask"
setfacl -R -d -m u::rwx "$HASS_CONFIG"
setfacl -R -d -m g::rwx "$HASS_CONFIG"
setfacl -R -d -m o::000 "$HASS_CONFIG"

echo
echo "Done!"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
