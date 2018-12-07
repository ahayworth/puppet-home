#!/bin/bash

sudo apt-get install -y ser2net
sudo /bin/bash -c "echo '3333:raw:0:/dev/ttyUSB0:19200 8DATABITS NONE 1STOPBIT -RTSCTS' > /etc/ser2net.conf"
sudo systemctl restart ser2net
