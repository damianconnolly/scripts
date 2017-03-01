#!/bin/bash

# Used as a module to break other scripts if disk space is too low

dfpercent=`df -h|grep /opt/WEBSITES |sed 's/%//'|awk '{print $4}'`
dfavail=`df -h|grep /opt/WEBSITES |sed 's/%//'|awk '{print $3}'`
min=80
RED='\e[1;31m'
NC='\e[0m'
if  [ $dfpercent -gt $min ] ; then
        echo -e ${RED}\
"#########################################################
#            There is over ${min}% disk space used          #
#     There's ${dfpercent}% used, available diskspace is ${dfavail}.    #
######################################################### "
echo -e $NC
echo -e "Are you sure you want to continue?"
read yn
case $yn in
  n|N|No|NO|no)
        kill `ps -ef |grep $$ |awk '{print $3}'`
        ;;
esac
fi

