#!/bin/bash

# Install by running:
# wget -Nnv https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/mqtt-dasher-wizard.sh && bash mqtt-dasher-wizard.sh

me=$(whoami)

USER_HOME=/home/$me
MQTT_DASHER_DIR=$USER_HOME/.mqtt-dasher
MQTT_DASHER_CONF=$MQTT_DASHER_DIR/config.yml
MQTT_DASHER_PROC=$MQTT_DASHER_DIR/process.json
MQTT_DASHER_WRAP=$MQTT_DASHER_DIR/mqtt-dasher

echo "MQTT Dasher Quick Installer"
echo "Copyright(c) 2016 Dale Higgs <https://gitter.im/dale3h>"
echo

echo "Running apt-get preparation"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git make

echo "Installing Node.js 4.x"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

NPM_PREFIX=$(npm prefix -g)

echo "Installing dependencies"
sudo apt-get install -y libpcap-dev

echo "Installing pm2 process manager"
sudo npm install -g pm2
sudo su -c "env PATH=$PATH:/usr/local/bin pm2 startup systemd -u $me --hp $USER_HOME"

echo "Installing mqtt-dasher"
sudo npm install -g mqtt-dasher

echo "Setting up mqtt-dasher config"
mkdir -p $MQTT_DASHER_DIR

IP_ADDRESS=$(ifconfig | awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')

echo "What is your MQTT broker host?"
read MQTT_HOST
echo
if [ ! "$MQTT_HOST" ]; then
    MQTT_HOST=localhost
fi

echo "What is your MQTT broker port?"
read MQTT_PORT
echo
if [ ! "$MQTT_PORT" ]; then
    MQTT_PORT=1883
fi

echo "What is your MQTT broker username?"
read MQTT_USERNAME
echo
if [ ! "$MQTT_USERNAME" ]; then
    MQTT_USERNAME=pi
fi

echo "What is your MQTT broker password?"
read -s MQTT_PASSWORD
echo
if [ ! "$MQTT_PASSWORD" ]; then
    MQTT_PASSWORD=raspberry
fi

FIND_BUTTONS=$NPM_PREFIX/lib/node_modules/mqtt-dasher/node_modules/node-dash-button/bin/findbutton

# echo -n "Would you like you scan for Dash buttons now (y/N)? "
# read -n1 SCAN_DASHER_NOW
# echo
# if [ "$SCAN_DASHER_NOW" == 'y' ] || [ "$SCAN_DASHER_NOW" == 'Y' ]; then
#     echo "This feature is not yet implemented"
# fi

echo "Writing mqtt-dasher config"
cat > $MQTT_DASHER_CONF <<EOF
---
mqtt:
  host: ${MQTT_USERNAME}:${MQTT_PASSWORD}@${MQTT_HOST}:${MQTT_PORT}

buttons:
  01:00:00:00:00:00: dash-button/bounty
  02:00:00:00:00:00: dash-button/dixie
  03:00:00:00:00:00: dash-button/finish
  04:00:00:00:00:00: dash-button/kraft
  05:00:00:00:00:00: dash-button/tide
EOF

echo "Writing mqtt-dasher wrapper"
cat > $MQTT_DASHER_WRAP <<EOF
#/bin/bash

ps aux | grep 'node' | grep 'bin/mqtt-dasher' | grep -vE 'grep' | awk '{print $2}' | sudo xargs kill -9
sudo ${NPM_PREFIX}/bin/mqtt-dasher
EOF

echo "Writing mqtt-dasher pm2 process file"
cat > $MQTT_DASHER_PROC <<EOF
{
  "apps": [
    {
      "name"             : "mqtt-dasher",
      "script"           : "./mqtt-dasher",
      "exec_interpreter" : "bash",
      "cwd"              : "${MQTT_DASHER_DIR}",
      "watch"            : false
    }
  ]
}
EOF

echo
echo "Starting mqtt-dasher with pm2"
pushd $MQTT_DASHER_DIR
pm2 start process.json
popd

echo "Saving pm2 startup list"
pm2 save

echo
echo "Done!"
echo
echo "To find your Dash buttons, run:"
echo "  $FIND_BUTTONS"
echo "and then update your config file:"
echo "  $MQTT_DASHER_CONF"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
echo
