#!/bin/bash

echo "===== MAPREDUCE ====="

echo "1 WordCount"
echo "2 Afficher résultat"
echo "3 Télécharger résultat"

read -p "Choix : " CH

case $CH in

1)

read -p "Input HDFS : " INPUT

read -p "Output HDFS : " OUTPUT

docker exec namenode bash -c "
hdfs dfs -rm -r -f $OUTPUT

hadoop jar \
/opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
wordcount \
$INPUT \
$OUTPUT
"

;;

2)

read -p "Output HDFS : " OUTPUT

docker exec namenode \
hdfs dfs -cat \
$OUTPUT/part-r-00000 | head -50

;;

3)

read -p "Output HDFS : " OUTPUT

docker exec namenode \
hdfs dfs -getmerge \
$OUTPUT \
/tmp/result.txt

docker cp \
namenode:/tmp/result.txt \
./result.txt

;;

esac