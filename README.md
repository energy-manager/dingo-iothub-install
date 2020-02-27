# Dingo IOT Hub Install

### Procedure

1. Clone this repository into home directory on Dingo
2. Run `./install-dingo-iothub.sh`
3. Check that the service is running `systemctl status dingo-iothub`
4. Delete directory `/install-dingo-iothub`
5. Stop openport from running as a daemon `sudo systemctl disable openport`
6. Stop openport `sudo systemctl stop openport`

If all went well Openport should be stopped on the Dingo and no longer running. You should be able to start it again via Azure IOT Hub.
