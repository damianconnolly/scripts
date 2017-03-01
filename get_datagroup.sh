#!/bin/bash
datagroup=${1}
user=${2}
pass=${3}
curl --insecure https://${user}:${pass}@10.241.175.243/mgmt/tm/ltm/data-group/internal/${datagroup}|grep -Po '\"name\":.*?[^\\]\",'|awk -F ':' '{print $2}'

