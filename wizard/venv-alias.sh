#!/bin/bash

# Install by running:
# curl -sL https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/venv-alias.sh | bash -

HASS_USER=homeassistant
VIRTUAL_ENV=/srv/homeassistant

ALIAS_FILE=$HOME/.bash_aliases
PROFILE_FILE=/home/$HASS_USER/.profile

add_venv_alias() {
  printf "\nalias venv='sudo su - $HASS_USER'\n" >> $ALIAS_FILE

  sudo -u $HASS_USER -i /bin/bash <<EOF
  printf "\nsource $VIRTUAL_ENV/bin/activate\n" >> $PROFILE_FILE
EOF

  source $ALIAS_FILE
}

add_venv_alias
