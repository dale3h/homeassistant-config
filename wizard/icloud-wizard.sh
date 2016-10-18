#!/bin/bash

# Install by running:
# wget -Nnv https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/icloud-wizard.sh && bash icloud-wizard.sh

ICLOUD_COMPONENT_URL="https://raw.githubusercontent.com/Bart274/icloudplatform/master/icloud.py"

users=($(whoami) hass homeassistant pi)

# Detect user
for i in "${users[@]}"; do
  ! id -u $i > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    test_path="/home/$i/.homeassistant"
    if [ -d "$test_path" ] && [ -f "$test_path/configuration.yaml" ]; then
      hass_user=$i
      hass_path=$test_path
      break
    fi
  fi
done

# Prompt for user if not detected
if [ -n "$hass_user" ]; then
  echo "Your Home Assistant user was detected as:"
  echo "  $hass_user"
  echo
else
  echo "Unable to automatically detect your Home Assistant user."
  echo "Common users include:"
  echo "  hass, homeassistant, pi"
  echo

  counter=3
  while [ $counter -gt 0 ]; do
    echo "What is your Home Assistant user?"
    read hass_user
    echo

    if [ -n "$hass_user" ]; then
      break
    fi

    let counter-=1
  done
fi

if [ -z "$hass_user" ]; then
  echo "Could not detect a valid Home Assistant user."
  exit 1
fi

# Detect .homeassistant path
if [ -z "$hass_path" ]; then
  test_path="/home/$hass_user/.homeassistant"
  if [ -d "$test_path" ] && [ -f "$test_path/configuration.yaml" ]; then
    hass_path=$test_path
  fi
fi

if [ -n "$hass_path" ]; then
  echo "Your Home Assistant configuration directory was detected as:"
  echo "  $hass_path"
  echo
else
  echo "Unable to automatically detect your Home Assistant configuration directory."
  echo "Common locations include:"
  echo "  /home/hass/.homeassistant"
  echo "  /home/homeassistant/.homeassistant"
  echo "  /home/pi/.homeassistant"
  echo

  counter=3
  while [ $counter -gt 0 ]; do
    echo "Where is your Home Assistant configuration directory?"
    read test_path
    test_path=${test_path%/}
    echo

    if [ -d "$test_path" ] && [ -f "$test_path/configuration.yaml" ]; then
      hass_path=$test_path
      break
    fi

    test_path="$test_path/.homeassistant"
    if [ -d "$test_path" ] && [ -f "$test_path/configuration.yaml" ]; then
      hass_path=$test_path
      break
    fi

    let counter-=1
  done
fi

if [ -z "$hass_path" ]; then
  echo "Could not detect a valid Home Assistant configuration directory."
  exit 1
fi

# Detect virtualenv path
use_venv=false

if [ -z "$venv_path" ]; then
  test_path="/srv/$hass_user"
  if [ -d "$test_path" ] && [ -f "$test_path/bin/activate" ]; then
    venv_path=$test_path
  fi
fi

if [ -z "$venv_path" ]; then
  test_path="/srv/$hass_user/${hass_user}_venv"
  if [ -d "$test_path" ] && [ -f "$test_path/bin/activate" ]; then
    venv_path=$test_path
  fi
fi

if [ -n "$venv_path" ]; then
  echo "Your Home Assistant virtualenv path was detected as:"
  echo "  $hass_path"
  echo
else
  echo "Unable to automatically detect your Home Assistant virtualenv path."
  echo "Common locations include:"
  echo "  /srv/hass"
  echo "  /srv/hass/hass_venv"
  echo "  /srv/homeassistant"
  echo "  /srv/homeassistant/homeassistant_venv"
  echo

  echo "Where is your Home Assistant virtualenv? (Press ENTER to skip)"
  read test_path
  test_path=${test_path%/}
  echo

  if [ -n "$test_path" ]; then
    use_venv=true
  else
    use_venv=false
  fi

  if [ -d "$test_path" ] && [ -f "$test_path/bin/activate" ]; then
    venv_path=$test_path
  fi
fi

if $use_venv && [ -z "$venv_path" ]; then
  use_venv=false
  echo "Could not detect a valid Home Assistant virtualenv path. Continuing without virtualenv."
fi

# The real magic is here
me=$(whoami)

if [ "$hass_user" != "$me" ]; then
  echo "Switching to user $hass_user"

  sudo -u $hass_user -H /bin/bash << EOF
  echo "Creating custom_components directory"
  mkdir -p $hass_path/custom_components

  echo "Downloading @Bart274's iCloud component"
  wget -nv $ICLOUD_COMPONENT_URL -O $hass_path/custom_components/icloud.py

  if $use_venv; then
    echo "Activating virtualenv"
    source $venv_path/bin/activate
  fi

  echo "Installing pyicloud"
  pip3 install pyicloud

  if $use_venv; then
    echo "Deactivating virtualenv"
    deactivate
  fi

  echo "Switching back to user $me"
EOF
else
  echo "Creating custom_components directory"
  mkdir -p $hass_path/custom_components

  echo "Downloading @Bart274's iCloud component"
  wget -nv $ICLOUD_COMPONENT_URL -O $hass_path/custom_components/icloud.py

  if $use_venv; then
    echo "Activating virtualenv"
    source $venv_path/bin/activate
  fi

  echo "Installing pyicloud"
  pip3 install pyicloud

  if $use_venv; then
    echo "Deactivating virtualenv"
    deactivate
  fi
fi

echo
echo "Done!"
echo
echo
echo "@Bart274's iCloud component is now installed."
echo
echo "Please update your configuration.yaml and add the following:"
echo
echo "################################################"
echo "icloud:"
echo "  !secret icloud_accountname:"
echo "    username: !secret icloud_username"
echo "    password: !secret icloud_password"
echo "################################################"
echo
echo "Please update your secrets.yaml and add the following:"
echo
echo "################################################"
echo "icloud_accountname: YOUR_NAME"
echo "icloud_username: YOUR@APPLE.ID"
echo "icloud_password: YOUR_PASSWORD"
echo "################################################"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
echo
