#!/bin/bash

while true
do

clear

echo "========================================"
echo " BIG DATA MANAGER"
echo "========================================"

echo "1  - Cluster Manager"
echo "2  - HDFS Manager"
echo "3  - MapReduce Manager"
echo "4  - YARN Manager"

echo "5  - Spark Manager"
echo "6  - Hive Manager"

echo "7  - Reporting"

echo "0  - Quitter"

case $CH in

1) bash modules/hdfs.sh ;;
2) bash modules/mapreduce.sh ;;
3) bash modules/spark.sh ;;
4) source modules/yarn.sh ;;
5) source modules/spark.sh ;;
6) source modules/hive.sh ;;
7) source modules/reports.sh ;;

0) exit ;;

*) echo "Choix invalide" ;;
esac

read -p "Entrée pour continuer..."
done
