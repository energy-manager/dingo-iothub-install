# Dingo IOT Hub Install

### Procedure

1. Clone this repository into home directory on Dingo (`git clone 'url'`)
2. Install JSON Parser jq(https://stedolan.github.io/jq/) `sudo apt-get install jq`
3. Run `./install-dingo-iothub.sh`
4. Check that the service is running `systemctl status dingo-iothub`
5. Delete directory `/install-dingo-iothub`
6. Stop openport from running as a daemon `sudo systemctl disable openport`
7. Stop openport `sudo systemctl stop openport`

If all went well Openport should be stopped on the Dingo and no longer running. You should be able to start it again via Azure IOT Hub.
