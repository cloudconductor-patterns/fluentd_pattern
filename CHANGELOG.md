CHANGELOG
=========

## version 1.1.0 (2015/09/30)

  - Support CloudConductor v1.1.
  - Remove the event_handler.sh, modified to control by the Metronome (task order control tool).Therefore, add the requirements(task.yml file etc.) to control from the Metronome.
  - Remove cloud_conductor_util gem from the required gems.
  - Add the requirements for test run in test-kitchen.

## version 1.0.1 (2015/04/16)

  - Fix td-agent version to 2.1.5-1 to avoid no_writable_error in case that log output directory does not exist.
  - Create the top directory of logs at setup.

## version 1.0.0 (2015/03/27)

  - First release of fluentd pattern that provides user with log collection feature.
