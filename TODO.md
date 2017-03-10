## Todo

* Look into NUT (Network UPS Tools)
  * https://home-assistant.io/components/sensor.nut/
  * Seek advice from @bassclarinetl2 and @quadflight
* Move HTTPS Proxy to Ubuntu machine
  * Update to support multiple proxies
  * Use nginx as a reverse proxy
* Add OZWCP to hass sidebar
  * Add an input boolean for toggling the Z-Wave network
  * Write a script to detect changes to zwcfg and restart hass if necessary?
* Add guest mode switch
  * Automatically toggle when a guest is present
  * Allow manual toggle
  * `persistent: true` in customize
* Fix front porch light to turn on only at night when arriving/leaving
* Figure out why input_select triggers a reset after changing (re: persistence)
* Add radar map (shell_command + local file)
* Remove redundant switches for automations
* Clean up customize.yaml to remove old/outdated entities
* Automate Good Morning/Night button
  * After 9pm, trigger good night script (unless already triggered)
  * After 5am, trigger good morning script (unless already triggered)
  * After 10am, toggle bedroom motion
* Normalize triggers, conditions, actions, scripts, etc with hyphens
* Organize groups better
* Iconify everything
* Add panic mode/security mode scene

## More Todo
* Decide if I want to keep Harmony Hub AND Broadlink RM2/Pro, or just switch to Broadlink RM2/Pro only, and sell the Harmony Hub
* Figure out a decent way to mount the projector
* Buy a web power switch for the rack
* Buy another ProSafe switch, rack mountable
* Find a cheap rack server to put Linux on, and run hass
* Find an affordable yet reliable rack PDU
* Find an affordable yet reliable rack UPS
* Rebuild Philips Hue network
* Rebuild Z-Wave network
* Setup Z-Wave minimotes for each room
* Buy more Z-Wave door/window sensors
* Replace garage door opener
* Buy a Garadget
* Make ethernet cables for each component
* Buy proper length, matching interconnects for all components

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