## Todo

* Update automation names
* Removal redundant switches for automations
* Clean up customize.yaml to remove old/outdated entities
* Remove possessive names and make singular
* Add names for new entities
* Automate Goodnight/Good Morning button
  * After 9pm, trigger goodnight script (unless already triggered)
  * After 5am, trigger good morning script (unless already triggered)
  * After 10am, toggle bedroom motion
* Move mqtt dash buttons to MQTT sensors
* Figure out a way to use templates in scenes
* Normalize triggers, conditions, actions, scripts, etc with hyphens
* Organize groups better
* Iconify everything
* Automate lights using door sensors and motion sensor
* Add full sexy time scene (music, lights, etc)
* Add panic mode/security mode scene
* Schedule backup, but figure out a way to delete old archives

## Discussion:

* Build web UI for managing config files
  * Use ACE for the editor
  * Need something to read/write files

* Genie Aladdin Connect integration
  * Possibly port to python package
  * Create custom component

* Occupancy component
  * Use an existing sensor to trigger
  * Stay on a configurable amount of time after the sensor was last active
  * How would templates affect this?
  * Brainstorm config:

    ```
    binary_sensor:
      platform: occupancy
      name: Bedroom Occupancy
      entity_id: sensor.bedroom_motion
      timer:
        minutes: 10
    ```

* Custom UPnP ports
  * Using "upnp" component
  * Using automation
  * Allow for options such as host, local port, remote port, name, etc
  * Allow for removal by automation

* Translations

## Pending Removal

* Nothing :)