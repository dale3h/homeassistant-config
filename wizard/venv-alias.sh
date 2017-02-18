#!/bin/bash

# Install by running:
#   curl -sL https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/venv-alias.sh | bash -
#
# You can also set the Home Assistant username and virtualenv path using:
#   curl -sL https://raw.githubusercontent.com/dale3h/homeassistant-config/master/wizard/venv-alias.sh | \
#     HASS_USER=hass \
#     VIRTUAL_ENV=/srv/hass/hass_venv \
#     bash -


HASS_USER=${HASS_USER:-homeassistant}
VIRTUAL_ENV=${VIRTUAL_ENV:-/srv/homeassistant}

ALIAS_FILE=$HOME/.bash_aliases
PROFILE_FILE=/home/$HASS_USER/.profile

add_venv_alias() {
  printf "\nalias venv='sudo su -s /bin/bash - $HASS_USER'\n" >> $ALIAS_FILE

  sudo -u $HASS_USER -i /bin/bash <<EOF
  printf "\nsource $VIRTUAL_ENV/bin/activate\n" >> $PROFILE_FILE
EOF

  source $ALIAS_FILE
}

add_venv_alias
