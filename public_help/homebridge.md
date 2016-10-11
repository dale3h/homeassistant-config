# Easy Install Instructions for Homebridge on Raspberry Pi

## Preparation

`sudo apt-get update`
`sudo apt-get upgrade`
`sudo apt-get install -y git make`

## Node.js

### Add Node.js repo to the apt-get source list

`curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -`

### Install Node.js

`sudo apt-get install -y nodejs`

### Confirm Installation

`npm --version`
`node --version`

## Dependencies

`sudo apt-get install -y libavahi-compat-libdnssd-dev`

## PM2 Process Manager

### Install PM2

`sudo npm install -g pm2`

### Add PM2 Startup Script

`pm2 startup systemd` (DO NOT USE SUDO FOR THIS!)

This will give you a command to run...run that command.

## Homebridge

### Install Homebridge and dependencies

`sudo npm install -g --unsafe-perm homebridge hap-nodejs node-gyp`
`cd /usr/lib/node_modules/homebridge/`
`sudo npm install --unsafe-perm bignum`
`cd /usr/lib/node_modules/hap-nodejs/node_modules/mdns`
`sudo node-gyp BUILDTYPE=Release rebuild`

### Install Homebridge plugin for Home Assistant

`sudo npm install -g homebridge-homeassistant`

### Configure Homebridge

`mkdir -p ~/.homebridge`
`touch ~/.homebridge/config.json`
`nano ~/.homebridge/config.json`

Copy/paste this config and edit to include your details (Home Assistant URL, password, and supported types):

```
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
      "host": "http://192.168.1.100:8123",
      "password": "YOUR_API_PASSWORD",
      "supported_types": ["light", "switch", "media_player", "scene"]
    }
  ]
}
```

## PM2ize it

### Add Homebridge to PM2

`cd ~/.homebridge`
`pm2 start homebridge`
`pm2 save`

### Pair with iOS

You should be able to scan the code with your iOS device to pair it.

## Troubleshooting

* To view the Homebridge logs, simply type `pm2 logs`, or more specifically `pm2 logs homebridge`
* To stop Homebridge, use `pm2 stop homebridge`
* To start Homebridge manually, use `pm2 start homebridge`
* To restart Homebridge manually, use `pm2 restart homebridge`
* To monitor PM2's processes, type `pm2 monit`

# Enjoy! :)
