`configuration.yaml`

```yaml
automation:
  - alias: Automation 1
    trigger:
      platform: state
      entity_id: device_tracker.iphone
      to: 'home'
    action:
      service: light.turn_on
      entity_id: light.entryway
  - alias: Automation 2
    trigger:
      platform: state
      entity_id: device_tracker.iphone
      from: 'home'
    action:
      service: light.turn_off
      entity_id: light.entryway
```

can be turned into:

`configuration.yaml`

```yaml
automation: !include_dir_merge_list automation/
```

`automation/presence.yaml`

```yaml
- alias: Automation 1
  trigger:
    platform: state
    entity_id: device_tracker.iphone
    to: 'home'
  action:
    service: light.turn_on
    entity_id: light.entryway
    
- alias: Automation 2
  trigger:
    platform: state
    entity_id: device_tracker.iphone
    from: 'home'
  action:
    service: light.turn_off
    entity_id: light.entryway
```

It is important to note that when using `!include_dir_merge_list`, you must include a list in each file (each list item is denoted with a hyphen [-]). Each file may contain one or more entries.