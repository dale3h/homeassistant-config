#!/bin/bash

# Install by running:
# wget -Nnv https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/pm2-wizard.sh && bash pm2-wizard.sh

me=$(whoami)

USER_HOME=/home/$me

echo "Node+PM2 Quick Installer"
echo "Copyright(c) 2016 Dale Higgs <https://gitter.im/dale3h>"
echo

echo "Running apt-get preparation"
sudo apt-get update
sudo apt-get upgrade

echo "Installing Node.js 6.x"
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing PM2 process manager"
sudo npm install -g pm2
sudo su -c "env PATH=$PATH:/usr/local/bin pm2 startup systemd -u $me --hp $USER_HOME"

node_version=$(node --version)
npm_version=$(npm --version)
pm2_version=$(pm2 --version)

echo
echo "node version: $node_version"
echo "npm version: $npm_version"
echo "pm2 version: $pm2_version"

echo
echo "Troubleshooting:"
echo
echo "* To view pm2 logs:         pm2 logs app-name"
echo "* To stop a pm2 process:    pm2 stop app-name"
echo "* To start a pm2 process:   pm2 start app-name"
echo "* To restart a pm2 process: pm2 restart app-name"
echo "* To monitor pm2 processes: pm2 monit"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
echo
