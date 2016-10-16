#!/bin/bash

sudo su -s /bin/bash hass
source /srv/hass/hass_venv/bin/activate

pip3 install --upgrade cython

cd /srv/hass/src
git clone --branch v0.3.1 https://github.com/OpenZWave/python-openzwave.git
cd python-openzwave
git checkout python3
make build
make install

# Might need to deactivate the virtualenv at this point

cd /srv/hass/src
sudo mkdir libmicrohttpd
sudo chown hass:hass libmicrohttpd
sudo wget ftp://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.19.tar.gz
sudo chown hass:hass libmicrohttpd-0.9.19.tar.gz
sudo tar zxvf libmicrohttpd-0.9.19.tar.gz

cd libmicrohttpd-0.9.19
sudo ./configure
sudo make
sudo make install

cd /srv/hass/src
sudo git clone https://github.com/OpenZWave/open-zwave-control-panel.git
sudo chown -R hass:hass open-zwave-control-panel

cd open-zwave-control-panel
sudo wget https://raw.githubusercontent.com/home-assistant/fabric-home-assistant/master/Makefile
sudo chown hass:hass -R Makefile
sudo make
sudo ln -sd /srv/hass/hass_venv/lib/python3.*/site-packages/libopenzwave-0.3.1-*-linux*.egg/config
sudo chown -R hass:hass /srv/hass/src/open-zwave-control-panel
