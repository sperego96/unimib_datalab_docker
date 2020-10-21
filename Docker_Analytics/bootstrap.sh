#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}
: ${HIVE_PREFIX:=/usr/local/apache-hive-3.1.2-bin}

/etc/init.d/ssh start
ssh -o StrictHostKeyChecking=no localhost 'exit'
ssh -o StrictHostKeyChecking=no 0.0.0.0 'exit'

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -


service sshd start
$HADOOP_PREFIX/sbin/start-all.sh
# $HADOOP_PREFIX/sbin/start-dfs.sh &
# $HADOOP_PREFIX/sbin/start-yarn.sh &
# Init HIVE
# $HIVE_PREFIX/bin/schematool -dbType derby -initSchema

# echo "------> Config folders"
# cd /home
# /usr/local/hadoop/bin/hadoop fs -mkdir -p ./dati
# /usr/local/hadoop/bin/hadoop fs -chmod +rwx ./dati/

# /usr/local/hadoop/bin/hadoop fs -mkdir /user/hive
# /usr/local/hadoop/bin/hadoop fs -mkdir /user/hive/warehouse
# /usr/local/hadoop/bin/hadoop fs -chmod g+w /user
# /usr/local/hadoop/bin/hadoop fs -chmod g+w /user/hive/warehouse

#/usr/local/apache-hive-3.1.2-bin/bin/init-hive-dfs.sh
# /usr/local/hadoop/bin/hadoop fs -chmod g+w /tmp


/bin/bash

