#!/bin/bash

while true
do

clear

echo "======================================="
echo " BIG DATA MANAGER "
echo "======================================="

echo "1 - Gestion HDFS"
echo "2 - Gestion MapReduce"
echo "3 - Gestion Spark"
echo "4 - Gestion Hive"
echo "5 - Gestion Cluster"
echo "6 - Rapports"

echo "0 - Quitter"

read -p "Choix : " CH

case $CH in

1) bash modules/hdfs.sh ;;
2) bash modules/mapreduce.sh ;;
3) bash modules/spark.sh ;;
4) bash modules/hive.sh ;;
5) bash modules/cluster.sh ;;
6) bash modules/reports.sh ;;

0) exit ;;

*) echo "Choix invalide" ;;
esac

read -p "Entrée pour continuer..."
done
