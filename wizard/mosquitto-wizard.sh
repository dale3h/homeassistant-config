#!/bin/bash

# Install by running:
# wget -Nnv https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/mosquitto-wizard.sh && sudo bash mosquitto-wizard.sh

echo "Mosquitto Quick Installer for Raspberry Pi"
echo "Copyright(c) 2016 Dale Higgs <https://gitter.im/dale3h>"
echo

echo "Adding mosquitto user"
useradd mosquitto

echo "Creating pid file"
touch /var/run/mosquitto.pid
chown mosquitto:mosquitto /var/run/mosquitto.pid

echo "Creating data directory"
mkdir -p /var/lib/mosquitto
chown mosquitto:mosquitto /var/lib/mosquitto

echo "Installing repo key"
cd /srv/hass/src
wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
apt-key add mosquitto-repo.gpg.key

echo "Adding repo"
cd /etc/apt/sources.list.d
wget http://repo.mosquitto.org/debian/mosquitto-jessie.list

echo "Installing mosquitto"
apt-get update
apt-cache search mosquitto
apt-get install -y mosquitto mosquitto-clients

echo "Writing default configuration"
cd /etc/mosquitto
mv mosquitto.conf mosquitto.conf.backup
wget https://raw.githubusercontent.com/home-assistant/fabric-home-assistant/master/mosquitto.conf
chown mosquitto:mosquitto mosquitto.conf

echo "Initializing password file"
touch passwd
chown mosquitto:mosquitto passwd
chmod 0600 passwd

echo
echo "Please take a moment to setup your first MQTT user"
echo

echo -n "Username: "
read mqtt_username
if [ ! "$mqtt_username" ]; then
  mqtt_username=pi
fi

echo -n "Password: "
read -s mqtt_password
echo
if [ ! "$mqtt_password" ]; then
  mqtt_password=raspberry
fi

echo "Creating password entry for user $mqtt_username"
mosquitto_passwd -b passwd "$mqtt_username" "$mqtt_password"

echo "Restarting mosquitto service"
systemctl restart mosquitto.service

ip_address=$(ifconfig | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')

echo
echo "Done!"
echo
echo "Your MQTT broker is running at $ip_address:1883"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
echo
