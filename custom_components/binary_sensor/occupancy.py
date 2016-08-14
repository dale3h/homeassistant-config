"""
Support for occupancy sensors (based on other entity states)

For more details about this component, please refer to the documentation at
https://home-assistant.io/components/binary_sensor/occupancy/
"""
import logging

from homeassistant.components.binary_sensor import (BinarySensorDevice,
                                                    SENSOR_CLASSES)
from homeassistant.const import (CONF_NAME, CONF_ENTITY_ID)

_LOGGER = logging.getLogger(__name__)

DEFAULT_NAME = "Binary Occupancy Sensor"
DEFAULT_SENSOR_CLASS = 'motion'


# pylint: disable=unused-argument
def setup_platform(hass, config, add_devices, discovery_info=None):
    """Setup the Occupancy binary sensor."""
    if config.get('entity_id') is None:
        _LOGGER.error('Missing required variable: "entity_id"')
        return False

    sensor_class = config.get('sensor_class', DEFAULT_SENSOR_CLASS)
    if sensor_class not in SENSOR_CLASSES:
        _LOGGER.warning('Unknown sensor class: %s', sensor_class)
        sensor_class = DEFAULT_SENSOR_CLASS

    add_devices([OccupancyBinarySensor(
        hass,
        False,
        config.get(CONF_NAME, DEFAULT_NAME),
        config.get(CONF_ENTITY_ID),
        sensor_class
    )])


class OccupancyBinarySensor(BinarySensorDevice):
    """An Occupancy binary sensor."""

    def __init__(self, hass, state, name, entity_id, sensor_class):
        """Initialize the Occupancy binary sensor."""
        self._hass = hass
        self._state = state
        self._name = name
        self._entity_id = entity_id
        self._sensor_class = sensor_class

    @property
    def is_on(self):
        """Return true if the binary sensor is on."""
        return self._state

    @property
    def name(self):
        """Return the name of the binary sensor."""
        return self._name

    @property
    def sensor_class(self):
        """Return the class of the binary sensor."""
        return self._sensor_class

    @property
    def should_poll(self):
        """No polling needed for an Occupancy binary sensor."""
        return False
