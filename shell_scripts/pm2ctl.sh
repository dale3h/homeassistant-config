#!/bin/bash

# Change these to suit your needs
PM2=/usr/bin/pm2
PM2_USER=pi
PM2_COMMANDS="start|stop|restart"
PM2_APPS="homebridge|dasher|smartthings-mqtt-bridge"

# Check for root privs
if [[ $UID != 0 ]]; then
  echo "Please run this script with sudo:"
  echo "  sudo $0 $*"
  exit 1
fi

# Function to show usage
usage() {
  echo "usage: $(basename $0) setup" 2>&1
  echo "usage: $(basename $0) {$PM2_COMMANDS} {$PM2_APPS}" 2>&1
  exit 1
}

# Show usage if no arguments given
if [[ $# -lt 1 ]]; then
  usage
fi

# Use extended globbing
shopt -s extglob

# Check for valid argument(s)
case "$1" in
  @($PM2_COMMANDS))
    case "$2" in
      @($PM2_APPS))
        su $PM2_USER -c "$PM2 $1 $2"
        ;;
      *)
        usage
        ;;
    esac
    ;;

  setup)
    SUDOERS_LINE="homeassistant ALL=(ALL) NOPASSWD: $(realpath $0)"

    if grep -xq "$SUDOERS_LINE" /etc/sudoers; then
      echo "This script already appears to have proper privileges."
      exit 0
    fi

    echo "Please run 'sudo visudo' and add the following line at the bottom:"
    echo "$SUDOERS_LINE"

    exit 1
    ;;

  # If no valid arguments found, show usage
  *)
    usage
    ;;
esac
