# mqtt

Most of the configuration here is done to support Sonoff and Ikea Zigbee devices in HA using Zigbee2Tasmota (Z2T)<https://tasmota.github.io/docs/Zigbee/>.

- Sonoff ZBBridge Pro as coordinator (main router of Zigbee network)
  - <https://zigbee.blakadder.com/Sonoff_ZBBridge-P.html>
- Sonoff ZBBridge as router (repeater)
  - <https://zigbee.blakadder.com/Sonoff_ZBBridge.html>
  - <https://digiblur.com/2022/02/20/how-to-convert-the-sonoff-zigbee-bridge-into-a-router-repeater/>

## Configuration

Required configuration of coordinator in Tasmota:

```
# Zigbee coordinator setup
## https://thehelpfulidiot.com/how-to-use-zigbee2tasmota-with-home-assistant

# Mqtt topic per device on zigbee coordinator
SetOption89 1

# Zigbee coordinator channel 20
zbconfig {"Channel":20}

# Add friendly name to zigbee device
ZBName <device>,<new_friendly_name>

# Friendly name as MQTT topic name
SetOption112 1

# Friendly name as prefix for payload (not shortaddress)
SetOption83 1

# Rule 1 for ZHA - https://zigbee.blakadder.com/Sonoff_ZBBridge.html

# To show battery life on Zigbee temperature sensors
## https://github.com/arendst/Tasmota/issues/9332#issuecomment-698829821
Rule2 on ?#temperature do zbsend {"Device":"%ZBDEVICE%","Read":{"BatteryPercentage":true}} endon
Rule2 1

Rule3 on ?#contact do zbsend {"Device":"%ZBDEVICE%","Read":{"BatteryPercentage":true}} endon
Rule3 1
```
