#!/bin/bash
# Crear estructura de directorios HDFS para Hive
hadoop fs -mkdir -p /user/hive/warehouse
hadoop fs -mkdir -p /tmp
hadoop fs -chmod g+w /user/hive/warehouse
hadoop fs -chmod g+w /tmp

# Cargar archivos AVRO
hadoop fs -mkdir -p /user/hive/avro_data
hadoop fs -put /data/userdata/*.avro /user/hive/avro_data/
hadoop fs -put /data/userdata/userdata.avsc /user/hive/avro_data/

echo "HDFS inicializado correctamente"