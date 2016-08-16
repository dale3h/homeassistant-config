"""
Provides functionality to interact with Telegram.

For more details about this component, please refer to the documentation at
https://home-assistant.io/components/telegram/
"""
import logging

import voluptuous as vol

from homeassistant.const import CONF_API_KEY

REQUIREMENTS = ['telepot==8.3']
DOMAIN = 'telegram'

CONF_CHAT_IDS = 'chat_ids'
CONF_USERS = 'users'
CONF_ADMINS = 'admins'

EVENT_INCOMING_BOT_MESSAGE = 'incoming_bot_message'

TELEGRAM = None

CONFIG_SCHEMA = vol.Schema({
    DOMAIN: vol.Schema({
        vol.Required(CONF_API_KEY): str,
<<<<<<< HEAD
        vol.Optional(CONF_CHAT_IDS): str,
        vol.Optional(CONF_USERS): str,
        vol.Optional(CONF_ADMINS): str
=======
         vol.Required(CONF_CHAT_IDS): str,
         vol.Required(CONF_USERS): str,
         vol.Optional(CONF_ADMINS): str
>>>>>>> c3793f48141730f528b5d0eb17b46f573506b27e
    })
}, extra=vol.ALLOW_EXTRA)

_LOGGER = logging.getLogger(__name__)


class TelegramBot(object):
    """Telegram Bot object"""

    def __init__(self, hass, config):
        """Initialize the Telegram Bot object."""
        import telepot

        conf = config[DOMAIN]

        api_key = conf.get(CONF_API_KEY)
        chat_ids = conf.get(CONF_CHAT_IDS)
        users = conf.get(CONF_USERS)
        admins = conf.get(CONF_ADMINS)

        _LOGGER.debug('Telegram Chat IDs: %s', chat_ids)
        _LOGGER.debug('Telegram Users: %s', users)
        _LOGGER.debug('Telegram Admins: %s', admins)

        self._hass = hass

        self._chat_ids = chat_ids
        self._users = users
        self._admins = admins

        self._bot = telepot.Bot(api_key)
        self._bot.message_loop(self.handle)

        self._me = self._bot.getMe()

<<<<<<< HEAD
        username = self._me.get('username')

        if username is not None:
            _LOGGER.info("Telegram bot is '%s'.", self._me.get('username'))
        else:
            _LOGGER.warning('Could not get Telegram bot username.')
=======
        _LOGGER.info("Telegram bot is '%s'.", self._me['username'])
>>>>>>> c3793f48141730f528b5d0eb17b46f573506b27e

    def handle(self, message):
        message = self.parse(message)

        _LOGGER.debug('Incoming Telegram: %s', message)

        self._hass.bus.fire(EVENT_INCOMING_BOT_MESSAGE, message)

    def parse(self, message):
        import telepot

        flavor = telepot.flavor(message)
        summary = telepot.glance(message, flavor=flavor)

        message['flavor'] = flavor
        message['summary'] = summary

        return message


def setup(hass, config):
    global TELEGRAM
    TELEGRAM = TelegramBot(hass, config)

    return True
