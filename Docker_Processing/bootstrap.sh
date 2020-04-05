#!/bin/bash

# start ssh server
/etc/init.d/ssh start

Host *
  UserKnownHostsFile /dev/null 
  StrictHostKeyChecking no
   
# Start Hadoop service
echo " -----> Starting Hadoop"
sh /usr/local/hadoop/hadoop-3.2.1/sbin/start-all.sh
echo " -----> Started Hadoop"