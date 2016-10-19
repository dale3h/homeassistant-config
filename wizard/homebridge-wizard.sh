#!/bin/bash

# Install by running:
# wget -Nnv https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/homebridge-wizard.sh && bash homebridge-wizard.sh

me=$(whoami)

USER_HOME=/home/$me
HOMEBRIDGE_CONF=$USER_HOME/.homebridge/config.json

echo "Homebridge Installer for Home Assistant"
echo "Copyright(c) 2016 Dale Higgs <https://gitter.im/dale3h>"
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
sudo su -c "env PATH=$PATH:/usr/local/bin pm2 startup systemd -u $me --hp $USER_HOME"

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

IP_ADDRESS=$(ifconfig | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')
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

HOMEBRIDGE_NAME=Homebridge
HOMEBRIDGE_PORT=51826

HEX_CHARS=0123456789ABCDEF
RANDOM_MAC=$( for i in {1..6} ; do echo -n ${HEX_CHARS:$(( $RANDOM % 16 )):1} ; done | sed -e 's/\(..\)/:\1/g' )
HOMEBRIDGE_USERNAME=CC:22:3D$RANDOM_MAC

HOMEBRIDGE_PIN=$(printf "%03d-%02d-%03d" $(($RANDOM % 999)) $(($RANDOM % 99)) $(($RANDOM % 999)))

cat > $HOMEBRIDGE_CONF <<EOF
{
  "bridge": {
    "name": "${HOMEBRIDGE_NAME}",
    "username": "${HOMEBRIDGE_USERNAME}",
    "port": ${HOMEBRIDGE_PORT},
    "pin": "${HOMEBRIDGE_PIN}"
  },

  "description": "This is an example configuration file for Homebridge that includes the Home Assistant plugin.",

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
echo "* To view the Homebridge logs:    pm2 logs homebridge"
echo "* To stop Homebridge:             pm2 stop homebridge"
echo "* To start Homebridge manually:   pm2 start homebridge"
echo "* To restart Homebridge manually: pm2 restart homebridge"
echo "* To monitor PM2 processes:       pm2 monit"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
echo
