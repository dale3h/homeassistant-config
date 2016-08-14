`configuration.yaml`

```yaml
group:
  bedroom:
    name: Bedroom
    entities:
      - light.bedroom_lamp
      - light.bedroom_overhead
  hallway:
    name: Hallway
    entities:
      - light.hallway
      - thermostat.home
  front_yard:
    name: Front Yard
    entities:
      - light.front_porch
      - light.security
      - light.pathway
      - sensor.mailbox
      - camera.front_porch
```

can be turned into:

`configuration.yaml`

```yaml
group: !include_dir_merge_named group/
```

`group/interior.yaml`

```yaml
bedroom:
  name: Bedroom
  entities:
    - light.bedroom_lamp
    - light.bedroom_overhead
hallway:
  name: Hallway
  entities:
    - light.hallway
    - thermostat.home
```

`group/exterior.yaml`

```yaml
front_yard:
  name: Front Yard
  entities:
    - light.front_porch
    - light.security
    - light.pathway
    - sensor.mailbox
    - camera.front_porch
```
