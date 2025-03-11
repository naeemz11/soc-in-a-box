#!/bin/bash

FORWARD_SERVER="10.13.99.2"
PORT="9997"
USERNAME="kali"
SERVER_IP="10.13.99.1"

ssh -t ${USERNAME}@${SERVER_IP} << EOF

wget -O splunkforwarder-9.4.0-6b4ebe426ca6-linux-amd64.tgz "https://download.splunk.com/products/univ>

tar -zxvf splunkforwarder-9.4.0-6b4ebe426ca6-linux-amd64.tgz

echo "[+] Moving Splunk files..."
sudo rsync -av /home/${USERNAME}/splunkforwarder/ /opt/splunkforwarder/

sudo /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt

sudo /opt/splunkforwarder/bin/splunk add forward-server ${FORWARD_SERVER}:${PORT} -auth admin:SuperSe>

sudo /opt/splunkforwarder/bin/splunk restart

EOF
