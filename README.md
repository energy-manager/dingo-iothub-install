# Dingo IOT Hub Install

### Procedure

1. Make sure the Azure service is running and that `start-at-startup` is on for the device
2. Clone this repository into home directory on Dingo (`git clone 'url'`)
3. Install JSON Parser jq(https://stedolan.github.io/jq/) `sudo apt-get install jq`
4. Run `./install-dingo-iothub.sh`
5. Check that the service is running `systemctl status dingo-iothub`
6. Delete directory `/install-dingo-iothub`
7. Stop openport from running as a daemon `sudo systemctl disable openport`
8. Stop openport `sudo systemctl stop openport`

If all went well Openport should be stopped on the Dingo and no longer running. You should be able to start it again via Azure IOT Hub.
