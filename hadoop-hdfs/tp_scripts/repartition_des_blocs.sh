echo ""
echo "===== REPARTITION DES BLOCS ====="

hdfs fsck \
$PARQUET_DIR/$PARQUET_FILE \
-files -blocks -locations \
| grep DatanodeInfo