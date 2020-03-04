# Dingo IOT Hub Install

### Procedure

1. Clone this repository into home directory on Dingo
2. Install JSON Parser jq(https://stedolan.github.io/jq/) `sudo apt-get install jq`
3. Use the bacnet http link through Openport to find the correct app-identifier and property-identifier if you do not have it
4. Set permissions on script `cd dingo-iothub && chmod 755 install-dingo-iothub`
5. Run `./install-dingo-iothub.sh -a -p` with `a` being the app-identifier and `p` being the property-identifier
6. Check that the service is running `systemctl status dingo-iothub`
7. Delete directory `rm -rf /install-dingo-iothub` 
8. Stop openport from running as a daemon `sudo systemctl disable openport`
9. Stop openport `sudo openport -K`

If all went well Openport should be stopped on the Dingo and no longer running. You should be able to start it again via Azure IOT Hub.
