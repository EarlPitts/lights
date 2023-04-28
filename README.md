# Lights

A simple script for controlling the ambient lighting in our living room with a raspberry.
It syncs with some weather API, so the LEDs turn on when the sun sets.
It just caches this data, and checks if the sunset is within 5 minutes, and if so, turns on the power on the corresponding USB connector, which has some christmas lights attached.
It can be used with e.g. a simple cronjob that runs it at 5 min intervals in the afternoon.

## Dependencies

- `Racket`:
    - `gregor` (for dates)
    - `http-easy`
- `uhubctl` (for controlling the USB power)
