#!/bin/bash

echo "===== CLUSTER ====="

echo "1 Etat cluster"
echo "2 Stop DataNode1"
echo "3 Start DataNode1"
echo "4 SafeMode ON"
echo "5 SafeMode OFF"

read -p "Choix : " CH

case $CH in

1)

docker exec namenode \
hdfs dfsadmin -report

docker exec namenode \
yarn node -list

;;

2)

docker stop datanode1

;;

3)

docker start datanode1

;;

4)

docker exec namenode \
hdfs dfsadmin -safemode enter

;;

5)

docker exec namenode \
hdfs dfsadmin -safemode leave

;;

esac