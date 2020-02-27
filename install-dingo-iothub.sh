#!/usr/bin/bash

SERVICE_NAME=$('dingo-iothub')
DESCRIPTION=$('Dingo IOT Hub for connecting and controlling dingo remotely')
DIR_PATH=$('/usr/bin')
FILE_PATH=$('/usr/bin/dingo-iothub')

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
    mv ./dingo-iothub $FILE_PATH
    echo "Setting permissions on $FILE_PATH"
    sudo chmod +x $FILE_PATH
  fi
  echo "Creating service file"
  sudo cat > /etc/systemd/system/${SERVICE_NAME//'"'/}.service << EOF
[Unit]
Description=$DESCRIPTION
After=network.target

[Service]
ExecStart=$PATH $SERVICE_NAME
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
   # restart daemon, enable and start service
    echo "Reloading daemon and enabling service"
    sudo systemctl daemon-reload 
    sudo systemctl enable ${SERVICE_NAME//'.service'/} # remove the extension
    sudo systemctl start ${SERVICE_NAME//'.service'/}
    echo "Service Started"
fi

exit 0