#!/bin/bash

REPORT=rapport_bigdata.txt

echo "===== RAPPORT BIG DATA =====" > $REPORT

echo "" >> $REPORT

docker exec namenode \
hdfs dfsadmin -report >> $REPORT

echo "" >> $REPORT

docker exec namenode \
yarn node -list >> $REPORT

echo ""
echo "Rapport généré : $REPORT"