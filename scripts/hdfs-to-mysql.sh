#!/bin/bash
# Esperar que MySQL esté disponible
until mysql -h mysql -u root -proot -e "SELECT 1"; do
  echo "Esperando a MySQL..."
  sleep 5
done

# Crear tabla en MySQL
mysql -h mysql -u root -proot -e "
USE hive_summary;
CREATE TABLE IF NOT EXISTS country_summary (
  country VARCHAR(100),
  user_count INT
);
"

# Descargar el CSV de HDFS
hadoop fs -get /user/hive/summary/*.csv /tmp/summary.csv

# Importar datos a MySQL
mysql -h mysql -u root -proot hive_summary -e "
LOAD DATA LOCAL INFILE '/tmp/summary.csv' 
INTO TABLE country_summary
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
"

echo "Datos transferidos a MySQL correctamente"