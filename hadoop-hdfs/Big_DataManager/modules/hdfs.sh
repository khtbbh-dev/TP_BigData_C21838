#!/bin/bash

echo "===== HDFS ====="

echo "1 Upload fichier"
echo "2 Lister HDFS"
echo "3 Infos blocs"
echo "4 Modifier réplication"
echo "5 Permissions"
echo "6 Utilisation disque"

read -p "Choix : " CH

case $CH in

1)

read -p "Fichier local : " FILE

read -p "Destination HDFS : " DEST

FILE_NAME=$(basename "$FILE")

docker cp "$FILE" namenode:/tmp/

docker exec namenode bash -c "
hdfs dfs -mkdir -p $DEST
hdfs dfs -put -f /tmp/$FILE_NAME $DEST
"

;;

2)

read -p "Dossier HDFS : " DIR

docker exec namenode hdfs dfs -ls "$DIR"

;;

3)

read -p "Fichier HDFS : " FILE

docker exec namenode \
hdfs fsck "$FILE" \
-files -blocks -locations

;;

4)

read -p "Fichier HDFS : " FILE

read -p "Replication : " REP

docker exec namenode \
hdfs dfs -setrep -w "$REP" "$FILE"

;;

5)

read -p "Fichier : " FILE

read -p "Permissions : " PERM

docker exec namenode \
hdfs dfs -chmod "$PERM" "$FILE"

;;

6)

read -p "Chemin HDFS : " DIR

docker exec namenode \
hdfs dfs -du -s -h "$DIR"

;;

esac