#!/usr/bin/env bash
# Home Assistant Raspberry Pi Installer Kickstarter
# Copyright (C) 2017 Jonathan Baginski - All Rights Reserved
# Permission to copy and modify is granted under the MIT License
# Last revised 1/30/2017

## Run pre-install apt package dependency checks ##

while getopts ":n" opt; do
  case $opt in
    n)

    me=$(whoami)


    sudo apt-get update

    PKG_PYDEV=$(dpkg-query -W --showformat='${Status}\n' python-dev|grep "install ok installed")
    echo Checking for python-dev: $PKG_PYDEV
    if [ "" == "$PKG_PYDEV" ]; then
      echo "No python-dev. Setting up python-dev."
      sudo apt-get --force-yes --yes install python-dev
    fi

    PKG_PYPIP=$(dpkg-query -W --showformat='${Status}\n' python-pip|grep "install ok installed")
    echo Checking for python-pip: $PKG_PYPIP
    if [ "" == "$PKG_PYPIP" ]; then
      echo "No python-pip. Setting up python-pip."
      sudo apt-get --force-yes --yes install python-pip
    fi

    PKG_GIT=$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")
    echo Checking for git: $PKG_GIT
    if [ "" == "$PKG_GIT" ]; then
      echo "No git. Setting up git."
      sudo apt-get --force-yes --yes install git
    fi

    PKG_LIBSSL_DEV=$(dpkg-query -W --showformat='${Status}\n' libssl-dev|grep "install ok installed")
    echo Checking for libssl-dev: $PKG_LIBSSL_DEV
    if [ "" == "$PKG_LIBSSL_DEV" ]; then
      echo "No libssl-dev. Setting up libssl-dev."
      sudo apt-get --force-yes --yes install libssl-dev
    fi

    PKG_LIBFFI_DEV=$(dpkg-query -W --showformat='${Status}\n' libffi-dev|grep "install ok installed")
    echo Checking for libffi-dev: $PKG_LIBFFI_DEV
    if [ "" == "$PKG_LIBFFI_DEV" ]; then
      echo "No libffi-dev. Setting up libffi-dev."
      sudo apt-get --force-yes --yes install libffi-dev
    fi

    PKG_APT_LISTCHANGES=$(dpkg-query -W --showformat='${Status}\n' apt-listchanges|grep "install ok installed")
    echo Checking for apt-listchanges: $PKG_APT_LISTCHANGES
    if [ "install ok installed" == "$PKG_APT_LISTCHANGES" ]; then
      echo "apt-listchanges installed. Removing."
      sudo apt-get --force-yes --yes remove apt-listchanges
    fi

	sudo pip install --upgrade pip
	sudo pip install --upgrade setuptools
	sudo pip install pycrypto
	sudo pip install cryptography
	sudo pip install packaging
	sudo pip install appdirs
	sudo pip install six
	sudo pip install fabric

    git clone https://github.com/home-assistant/fabric-home-assistant.git

    ( cd /home/$me/fabric-home-assistant && fab deploy_novenv -H localhost 2>&1 | tee installation_report.txt )
    exit
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

me=$(whoami)


sudo apt-get update

PKG_PYDEV=$(dpkg-query -W --showformat='${Status}\n' python-dev|grep "install ok installed")
echo Checking for python-dev: $PKG_PYDEV
if [ "" == "$PKG_PYDEV" ]; then
  echo "No python-dev. Setting up python-dev."
  sudo apt-get --force-yes --yes install python-dev
fi

PKG_PYPIP=$(dpkg-query -W --showformat='${Status}\n' python-pip|grep "install ok installed")
echo Checking for python-pip: $PKG_PYPIP
if [ "" == "$PKG_PYPIP" ]; then
  echo "No python3-pip. Setting up python-pip."
  sudo apt-get --force-yes --yes install python-pip
fi

PKG_GIT=$(dpkg-query -W --showformat='${Status}\n' git|grep "install ok installed")
echo Checking for git: $PKG_GIT
if [ "" == "$PKG_GIT" ]; then
  echo "No git. Setting up git."
  sudo apt-get --force-yes --yes install git
fi

PKG_LIBSSL_DEV=$(dpkg-query -W --showformat='${Status}\n' libssl-dev|grep "install ok installed")
echo Checking for libssl-dev: $PKG_LIBSSL_DEV
if [ "" == "$PKG_LIBSSL_DEV" ]; then
  echo "No libssl-dev. Setting up libssl-dev."
  sudo apt-get --force-yes --yes install libssl-dev
fi

PKG_LIBFFI_DEV=$(dpkg-query -W --showformat='${Status}\n' libffi-dev|grep "install ok installed")
echo Checking for libffi-dev: $PKG_LIBFFI_DEV
if [ "" == "$PKG_LIBFFI_DEV" ]; then
  echo "No libffi-dev. Setting up libffi-dev."
  sudo apt-get --force-yes --yes install libffi-dev
fi

PKG_APT_LISTCHANGES=$(dpkg-query -W --showformat='${Status}\n' apt-listchanges|grep "install ok installed")
echo Checking for apt-listchanges: $PKG_APT_LISTCHANGES
if [ "install ok installed" == "$PKG_APT_LISTCHANGES" ]; then
  echo "apt-listchanges installed. Removing."
  sudo apt-get --force-yes --yes remove apt-listchanges
fi

sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install pycrypto
sudo pip install cryptography
sudo pip install packaging
sudo pip install appdirs
sudo pip install six
sudo pip install fabric

git clone https://github.com/home-assistant/fabric-home-assistant.git


( cd /home/$me/fabric-home-assistant && fab deploy -H localhost 2>&1 | tee installation_report.txt )
exit
