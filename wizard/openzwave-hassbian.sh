#!/bin/bash

# Install by running:
# wget -Nnv https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/openzwave-hassbian.sh && sudo bash openzwave-hassbian.sh

echo "Open Z-Wave Installer for Hassbian"
echo "Copyright(c) 2016 Dale Higgs <https://gitter.im/dale3h>"
echo

echo "Running apt-get preparation"
apt-get update
apt-get upgrade
apt-get install -y git make

echo "Installing latest version of cython"
pip3 install --upgrade cython

echo "Creating source directory"
mkdir -p /srv/homeassistant/src
chown -R homeassistant:homeassistant /srv/homeassistant/src

echo "Cloning python-openzwave"
cd /srv/homeassistant/src
git clone --branch v0.3.1 https://github.com/OpenZWave/python-openzwave.git

echo "Building python-openzwave"
chown homeassistant:homeassistant python-openzwave
cd python-openzwave
git checkout python3
make build
make install

echo "Creating libmicrohttpd directory"
cd /srv/homeassistant/src
mkdir libmicrohttpd
chown homeassistant:homeassistant libmicrohttpd

echo "Downloading libmicrohttpd-0.9.19"
wget ftp://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.19.tar.gz
chown homeassistant:homeassistant libmicrohttpd-0.9.19.tar.gz
tar zxvf libmicrohttpd-0.9.19.tar.gz
chown homeassistant:homeassistant libmicrohttpd-0.9.19

echo "Building libmicrohttpd-0.9.19"
cd libmicrohttpd-0.9.19
./configure
make
make install

echo "Cloning open-zwave-control-panel"
cd /srv/homeassistant/src
git clone https://github.com/OpenZWave/open-zwave-control-panel.git
chown -R homeassistant:homeassistant open-zwave-control-panel

echo "Building open-zwave-control-panel"
cd open-zwave-control-panel
wget https://raw.githubusercontent.com/home-assistant/fabric-home-assistant/master/Makefile
chown homeassistant:homeassistant Makefile
make

echo "Linking ozwcp config directory"
ln -sd /srv/homeassistant/lib/python3.*/site-packages/libopenzwave-0.3.1-*-linux*.egg/config
chown -R homeassistant:homeassistant /srv/homeassistant/src

echo
echo "Done!"
echo
echo "If you have issues with this script, please contact @dale3h on gitter.im"
echo
