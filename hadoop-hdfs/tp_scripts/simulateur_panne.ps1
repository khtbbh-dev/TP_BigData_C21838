Write-Host ""
Write-Host "===== ETAT AVANT PANNE ====="

docker exec namenode hdfs dfsadmin -report

Write-Host ""
Write-Host "===== ARRET DATANODE1 ====="

docker stop datanode1

Start-Sleep -Seconds 40

Write-Host ""
Write-Host "===== ETAT APRES PANNE ====="

docker exec namenode hdfs dfsadmin -report