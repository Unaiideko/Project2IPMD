#!/bin/bash
echo "Inicializando HDFS..."
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -chmod g+w /tmp

# Cargar archivos AVRO
hdfs dfs -mkdir -p /user/hive/avro_data
hdfs dfs -put /data/userdata/*.avro /user/hive/avro_data/