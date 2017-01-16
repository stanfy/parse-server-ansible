#!/bin/bash

inventoryDir='inventories'
packages='python aptitude'

if [ $# -lt 1 ]
then
	echo "Usage: ./$0  typeOfConfiguration [optionalPort]"
  exit 1
fi

customPort='22'

if [ $# -eq 2 ]
then
	customPort="$2"
fi

config="$inventoryDir/$1"

if [ -f "$config" ]
then
  ips=$(grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' "$config")
  for ip in $ips
  do
    ssh -o ConnectTimeout=7 -p "$customPort" root@$ip "apt-get install -y $packages"
  done
else
  echo "[ERROR] config $config is not found "
fi
