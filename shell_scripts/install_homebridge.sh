#!/bin/bash

USER_HOME=/home/pi
HOMEBRIDGE_CONF=$USER_HOME/.homebridge/config.test.json
IP_ADDRESS=$(ifconfig | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')

echo "Homebridge Simple Installer for Raspberry Pi and Home Assistant"
echo "Copyright(c) 2016 Dale Higgs <dale3h@gmail.com>"
echo

echo "Running apt-get preparation"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git make

echo "Installing Node.js 4.x"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing dependencies"
sudo apt-get install -y libavahi-compat-libdnssd-dev

echo "Installing PM2 process manager"
sudo npm install -g pm2
sudo su -c "env PATH=$PATH:/usr/local/bin pm2 startup systemd -u pi --hp $USER_HOME"

echo "Installing Homebridge"
sudo npm install -g --unsafe-perm homebridge hap-nodejs node-gyp
pushd /usr/local/lib/node_modules/homebridge/
sudo npm install --unsafe-perm bignum
pushd /usr/local/lib/node_modules/hap-nodejs/node_modules/mdns
sudo node-gyp BUILDTYPE=Release rebuild
popd
popd

echo "Installing Homebridge plugin for Home Assistant"
sudo npm install -g homebridge-homeassistant

echo "Setting up Homebridge config"
mkdir -p $USER_HOME/.homebridge

echo -n "Enter your Home Assistant IP: [$IP_ADDRESS] "
read HOMEASSISTANT_IP
if [ ! "$HOMEASSISTANT_IP" ]; then
    HOMEASSISTANT_IP=$IP_ADDRESS
fi

echo -n "Enter your Home Assistant port: [8123] "
read HOMEASSISTANT_PORT
if [ ! "$HOMEASSISTANT_PORT" ]; then
    HOMEASSISTANT_PORT=8123
fi

echo -n "Enter your Home Assistant API password: "
read -s HOMEASSISTANT_PASSWORD
echo

echo -n "Do you have HTTPS enabled? [y/N] "
read -n1 HOMEASSISTANT_HTTPS
HOMEASSISTANT_PROTOCOL=http
if [ "$HOMEASSISTANT_HTTPS" == 'y' ] || [ "$HOMEASSISTANT_HTTPS" == 'Y' ]; then
    HOMEASSISTANT_PROTOCOL=https
fi

cat > $HOMEBRIDGE_CONF <<EOF
{
  "bridge": {
    "name": "Homebridge",
    "username": "CC:22:3D:E3:CE:30",
    "port": 51826,
    "pin": "031-45-154"
  },

  "description": "This is an example configuration file for Home Assistant.",

  "accessories": [
  ],

  "platforms": [
    {
      "platform": "HomeAssistant",
      "name": "HomeAssistant",
      "host": "${HOMEASSISTANT_PROTOCOL}://${HOMEASSISTANT_IP}:${HOMEASSISTANT_PORT}",
      "password": "${HOMEASSISTANT_PASSWORD}",
      "supported_types": ["light", "switch", "media_player", "scene"]
    }
  ]
}
EOF

echo
echo "The Homebridge config will now open. Please confirm that everything is correct before closing."
echo

read -p "Press [enter] to continue..." -s
nano $HOMEBRIDGE_CONF

echo
echo "Adding Homebridge to PM2"
pushd $USER_HOME/.homebridge
pm2 start homebridge
pm2 save
popd

echo
echo "You should be able to scan the code with your iOS device to pair it."
echo
echo "Troubleshooting:"
echo
echo "* To view the Homebridge logs: pm2 logs homebridge"
echo "* To stop Homebridge: pm2 stop homebridge"
echo "* To start Homebridge manually: pm2 start homebridge"
echo "* To restart Homebridge manually: pm2 restart homebridge"
echo "* To monitor PM2 processes: pm2 monit"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
echo
