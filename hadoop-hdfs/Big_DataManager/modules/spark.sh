#!/bin/bash

echo "===== SPARK ====="

echo "1 Exécuter script PySpark"

read -p "Choix : " CH

case $CH in

1)

read -p "Script local : " FILE

docker cp "$FILE" spark-master:/tmp/

SCRIPT=$(basename "$FILE")

docker exec spark-master \
spark-submit /tmp/$SCRIPT

;;

esac