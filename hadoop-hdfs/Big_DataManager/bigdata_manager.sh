#!/bin/bash

while true
do

clear

echo "========================================"
echo "      BIG DATA MANAGER    "
echo "========================================"
echo ""
echo "1 - Cluster Manager"
echo "2 - HDFS Manager"
echo "3 - MapReduce Manager"
echo "4 - YARN Manager"
echo "5 - Spark Manager"
echo "6 - Hive Manager"
echo "7 - Reports Manager"
echo ""
echo "0 - Quitter"
echo ""

read -p "Choix : " CH

case $CH in

1)
    source modules/cluster.sh
    ;;

2)
    source modules/hdfs.sh
    ;;

3)
    source modules/mapreduce.sh
    ;;

4)
    source modules/yarn.sh
    ;;

5)
    source modules/spark.sh
    ;;

6)
    source modules/hive.sh
    ;;

7)
    source modules/reports.sh
    ;;

0)
    exit
    ;;

*)
    echo "Choix invalide"
    sleep 2
    ;;

esac

done
```
