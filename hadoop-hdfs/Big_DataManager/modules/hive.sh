#!/bin/bash

echo "===== HIVE ====="

echo "1 Exécuter requête"

read -p "Requête SQL : " SQL

docker exec hive-server \
beeline \
-u jdbc:hive2://localhost:10000 \
-e "$SQL"