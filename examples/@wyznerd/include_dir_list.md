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
automation: !include_dir_list automation/presence/
```

`automation/presence/automation1.yaml`

```yaml
alias: Automation 1
trigger:
  platform: state
  entity_id: device_tracker.iphone
  to: 'home'
action:
  service: light.turn_on
  entity_id: light.entryway
```

`automation/presence/automation2.yaml`

```yaml
alias: Automation 2
trigger:
  platform: state
  entity_id: device_tracker.iphone
  from: 'home'
action:
  service: light.turn_off
  entity_id: light.entryway
```

It is important to note that each file must contain only **one** entry when using `!include_dir_list`.