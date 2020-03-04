#!/bin/bash

SERVICE_NAME='dingo-iothub'
DESCRIPTION='Dingo IOT Hub for connecting and controlling Dingo remotely'
DIR_PATH='/usr/bin'
FILE_PATH='/usr/bin/dingo-iothub'
APP_ID=""
PROP_ID=""

while getopts a:p: option do
  case "${option}" in
    a) APP_ID="${OPTARG}";;
    p) PROP_ID="${OPTARG}";;
  esac
done

function _jq() {
  echo $1 | base64 --decode | jq -r $2
}

function get_connection_string() {
  SERVICES=$(curl -s "http://localhost/bacnetws/apps/instances?alt=json")

  for row in $(echo "${SERVICES}" | jq -r '.[] | @base64'); do
    APP_IDENTIFIER=$(_jq $row '.["app-identifier"]')
    STARTUP=$(_jq $row '.["start-at-startup"]')

    if [ "$APP_IDENTIFIER" == "$APP_ID" ] && [ $STARTUP == "1" ]
    then
      OBJECT_ID=$(_jq $row '.["object-identifier"]')
      break
    fi
  done

  PROPERTIES=$(curl -s "http://localhost/bacnetws/apps/property-instances?filter=app-identifier%20eq%20'${OBJECT_ID}'&alt=json")

  for row in $(echo "${PROPERTIES}" | jq -r '.[] | @base64'); do
    PROP_IDENTIFIER=$(_jq $row '.["property-identifier"]')

    if [[ "$PROP_IDENTIFIER" == "$PROP_ID" ]]
    then
      CONNECTION_STRING=$(_jq $row '.["value"]')
      break
    fi
  done

  echo $CONNECTION_STRING
}

IS_ACTIVE=$(sudo systemctl is-active $SERVICE_NAME)
if [ "$IS_ACTIVE" == "active" ]; then
  # restart the service
  echo "Service is running"
  echo "Restarting service"
  sudo systemctl restart $SERVICE_NAME
  echo "Service restarted"
else
  if [ -f "$FILE_PATH" ]; then
    echo "$FILE_PATH already exists"
  else 
    echo "Moving file to $FILE_PATH"
    sudo cp ./dingo-iothub $FILE_PATH
    echo "Setting permissions on $FILE_PATH"
    sudo chmod +x $FILE_PATH
  fi
  echo "Creating service file"
  EXEC=$(printf "%s %s" ${FILE_PATH} $(get_connection_string))
  sudo cat > ./${SERVICE_NAME}.service << EOF
[Unit]
Description=$DESCRIPTION
After=network.target

[Service]
ExecStart=$EXEC
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  # restart daemon, enable and start service
  sudo mv ./${SERVICE_NAME}.service /etc/systemd/system       
  sudo chmod 644 /etc/systemd/system/${SERVICE_NAME}.service  
  echo "Reloading daemon and enabling service"
  sudo systemctl daemon-reload 
  sudo systemctl enable $SERVICE_NAME 
  sudo systemctl start $SERVICE_NAME
  echo "Service Started"
fi

exit 0