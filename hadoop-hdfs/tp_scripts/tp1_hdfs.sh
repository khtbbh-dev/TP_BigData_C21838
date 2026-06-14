#!/bin/bash

# ==================================================
# TP 1 HDFS AUTOMATIQUEMENT
# ==================================================

USER_NAME="elkheit"
HDFS_HOME="/user/$USER_NAME"

INPUT_DIR="$HDFS_HOME/data/input"
PARQUET_DIR="$HDFS_HOME/data/parquet"

PARQUET_FILE="yellow_tripdata_2023-01.parquet"

REPORT="/tmp/rapport_tp_hdfs.txt"

echo "=========================================" | tee $REPORT
echo "RAPPORT TP HDFS" | tee -a $REPORT
echo "=========================================" | tee -a $REPORT

echo "" | tee -a $REPORT
echo "1. Creation des repertoires" | tee -a $REPORT

hdfs dfs -mkdir -p $INPUT_DIR
hdfs dfs -mkdir -p $PARQUET_DIR

hdfs dfs -ls /user | tee -a $REPORT

echo "" | tee -a $REPORT
echo "2. Upload du fichier parquet" | tee -a $REPORT

if [ -f "/tmp/$PARQUET_FILE" ]; then

    hdfs dfs -put -f /tmp/$PARQUET_FILE $PARQUET_DIR/

    echo "Upload OK" | tee -a $REPORT

else

    echo "ERREUR : fichier absent dans /tmp" | tee -a $REPORT
    exit 1

fi

echo "" | tee -a $REPORT
echo "3. Contenu du dossier parquet" | tee -a $REPORT

hdfs dfs -ls $PARQUET_DIR | tee -a $REPORT

echo "" | tee -a $REPORT
echo "4. Utilisation disque" | tee -a $REPORT

hdfs dfs -du -s -h $HDFS_HOME | tee -a $REPORT

echo "" | tee -a $REPORT
echo "5. Analyse des blocs" | tee -a $REPORT

hdfs fsck \
$PARQUET_DIR/$PARQUET_FILE \
-files -blocks -locations | tee -a $REPORT

echo "" | tee -a $REPORT
echo "6. Replication = 2" | tee -a $REPORT

hdfs dfs -setrep -w 2 \
$PARQUET_DIR/$PARQUET_FILE

hdfs fsck \
$PARQUET_DIR/$PARQUET_FILE \
-files -blocks -locations | tee -a $REPORT

echo "" | tee -a $REPORT
echo "7. Rapport cluster" | tee -a $REPORT

hdfs dfsadmin -report | tee -a $REPORT

echo "" | tee -a $REPORT
echo "Rapport genere :" | tee -a $REPORT

echo "$REPORT"

echo ""
echo "TERMINE"