#!/bin/bash

source /root/.profile

if [ -z "${password}" ]; then
  echo "Pls enter new password"
  read password
  echo export password="$password" >> /root/.profile
fi

systemctl stop node_util
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/install/node_util.service -O /etc/systemd/system/node_util.service
systemctl daemon-reload
systemctl enable node_util
systemctl start node_util
mkdir /root/util/ -p
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/install/util -O /root/util/run.sh
mkdir /root/util/massa/ -p
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/install/massa/roll_watcher.sh -O /root/util/massa/roll_watcher.sh
