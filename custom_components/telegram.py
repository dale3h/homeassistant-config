"""
Provides functionality to interact with Telegram.

For more details about this component, please refer to the documentation at
https://home-assistant.io/components/telegram/
"""
import logging

import voluptuous as vol

from homeassistant.const import CONF_API_KEY
import homeassistant.helpers.config_validation as cv

REQUIREMENTS = ['telepot==8.3']
DOMAIN = 'telegram'

# CONF_CHAT_IDS = 'chat_ids'
# CONF_USERS = 'users'
# CONF_ADMINS = 'admins'

PLATFORM_SCHEMA = vol.Schema({
    vol.Required(CONF_API_KEY): cv.string,
#     vol.Required(CONF_CHAT_IDS): cv.string,
#     vol.Required(CONF_USERS): cv.string,
#     vol.Optional(CONF_ADMINS): cv.string,
})

API_KEY = None
# CHAT_IDS = None
# USERS = None
# ADMINS = None

TELEGRAM = None

_LOGGER = logging.getLogger(__name__)


def setup(hass, config):
    global TELEGRAM, API_KEY
#     global API_KEY, CHAT_IDS, USERS, ADMINS

    conf = config[DOMAIN]

    API_KEY = conf[CONF_API_KEY]
#     CHAT_IDS = conf[CONF_CHAT_IDS]
#     USERS = conf[CONF_USERS]
#     ADMINS = conf[CONF_ADMINS]

    import telepot

    TELEGRAM = telepot.Bot(API_KEY)
    TELEGRAM.message_loop(handle_message)

    return True

def handle_message(message):
    _LOGGER.info('Incoming Telegram:', message)
