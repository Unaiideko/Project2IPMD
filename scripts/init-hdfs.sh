#!/bin/bash
echo "Creating hdfs project structure..."

# Crear y asignar permisos en HDFS
hdfs dfs -mkdir -p hdfs://namenode/user/hive
hdfs dfs -chown hive hdfs://namenode/user/hive
hdfs dfs -mkdir -p hdfs://namenode/user/hive/warehouse
hdfs dfs -chown hive hdfs://namenode/user/hive/warehouse
hdfs dfs -mkdir -p hdfs://namenode/home/hive
hdfs dfs -chown hive hdfs://namenode/home/hive

# Crear directorio en HDFS
hdfs dfs -mkdir -p hdfs://namenode/user/hive/userdata/
hdfs dfs -chown hive hdfs://namenode/user/hive/userdata/
hdfs dfs -mkdir -p hdfs://namenode/user/hive/estructura/
hdfs dfs -chown hive hdfs://namenode/user/hive/estructura/

echo "Uploading data to hdfs..."

# Subir archivos AVRO a HDFS
hadoop fs -mkdir -p /user/hive/warehouse/usuarios
hadoop fs -put /data/userdata/*.avro /user/hive/warehouse/usuarios/
hadoop fs -chmod -R 777 /user/hive/warehouse/usuarios
hdfs dfs -put /estructura/* hdfs://namenode/user/hive/estructura/

echo "✅ Datos AVRO cargados en HDFS correctamente."