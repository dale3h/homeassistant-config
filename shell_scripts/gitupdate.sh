#!/bin/bash

# Check Home Assistant config and push changes to git repo
# ========================================================
# License: MIT
# Author: Dale Higgs <@dale3h>
# Original Author: Carlo Costanzo <@CCOSTAN>
#
# Usage:
#   HASS_USER=hass \
#   HASS_CONFIG=/home/hass/.homeassistant \
#   HASS_VENV=/srv/hass/hass_venv \
#   ./gitupdate.sh <commit message>

# These variables can be overridden by environment variables
HASS_USER=${HASS_USER:-homeassistant}
HASS_CONFIG=${HASS_CONFIG:-/home/homeassistant/.homeassistant}
HASS_VENV=${HASS_VENV:-${VIRTUAL_ENV:-/srv/homeassistant}}

check_config() {
  # Initialize an empty variable
  CHECK_CMD=

  if [[ "$ACTIVATE_VENV" == "1" ]]; then
    # Activate venv command
    CHECK_CMD="source $HASS_VENV/bin/activate; "
  fi

  # Config check command
  CHECK_CMD="${CHECK_CMD}hass --script check_config -c $HASS_CONFIG"

  if [[ "$(whoami)" != "$HASS_USER" ]]; then
    # Run as Home Assistant user
    CHECK_OUTPUT=$(echo "$CHECK_CMD" | sudo -u $HASS_USER -H /bin/bash -)
  else
    # Run as current user
    CHECK_OUTPUT=$($CHECK_CMD)
  fi

  # Return an error code if any failures are present
  [[ ! "$CHECK_OUTPUT" =~ "Failed config" ]] &&
    [[ ! "$CHECK_OUTPUT" =~ "Config does not exist" ]] &&
    [[ ! "$CHECK_OUTPUT" =~ "Invalid config" ]]
}

# Check to see if we are already inside of the venv
if [[ ! -z "$VIRTUAL_ENV" ]]; then
  ACTIVATE_VENV=0
else
  # Check to see if the venv directory exists
  [[ ! -d "$HASS_VENV" ]]
  ACTIVATE_VENV=$?
fi

# Run the config check function
check_config

# If the config check failed, show the output and exit
if [[ "$?" != "0" ]]; then
  echo "$CHECK_OUTPUT"
  exit 1
fi

# Change to config directory
pushd $HASS_CONFIG >/dev/null

# Add all files to repo
git add .

# Show current status (after add)
git status

if [[ ! -z "$1" ]]; then
  # Take commit message from command line argument
  COMMIT_MSG="$1"
else
  # Prompt user for commit message
  echo -n "Enter a commit message: "
  read COMMIT_MSG
fi

# Commit files to repo
git commit -m "${COMMIT_MSG}"

# Push changes to origin
git push origin master

# Take the user back to their previous directory
popd >/dev/null

# Exit with no error code
exit 0
