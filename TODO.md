## Todo

* Removal redundant switches for automations
* Clean up customize.yaml to remove old/outdated entities
* Automate Good Morning/Night button
  * After 9pm, trigger good night script (unless already triggered)
  * After 5am, trigger good morning script (unless already triggered)
  * After 10am, toggle bedroom motion
* Move mqtt dash buttons to MQTT sensors
* Normalize triggers, conditions, actions, scripts, etc with hyphens
* Organize groups better
* Iconify everything
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

* Translations

## Pending Removal

* Nothing :)