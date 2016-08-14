You need to use an automation to accomplish what you're trying to do.

With two automations:

    automation:
      - trigger:
          platform: state
          entity_id: switch.magnetic
          to: 'on'
        action:
          service: switch.turn_on
          entity_id: switch.switch_31
      
      - trigger:
          platform: state
          entity_id: switch.magnetic
          to: 'off'
        action:
          service: switch.turn_off
          entity_id: switch.switch_31


It might also be possible with just one automation (untested):

    automation:
      - trigger:
          platform: state
          entity_id: switch.magnetic
        action:
          service_template: "switch.turn_{{ states('switch.magnetic') }}"
          entity_id: switch.switch_31

If the one-automation version produces an error, try using this instead:

    automation:
      - trigger:
          platform: state
          entity_id: switch.magnetic
        action:
          service_template: >
            {%- if states('switch.magnetic') == 'on' -%}
              switch.turn_on
            {%- else -%}
              switch.turn_off
            {%- endif -%}
          entity_id: switch.switch_31
