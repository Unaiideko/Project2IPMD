#!/bin/bash
echo "Creating HDFS project structure..."
# Crear y asignar permisos en HDFS
hdfs dfs -mkdir -p /user/hive
hdfs dfs -chown hive /user/hive
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chown hive /user/hive/warehouse
hdfs dfs -mkdir -p /home/hive
hdfs dfs -chown hive /home/hive
# Crear directorio en HDFS para los datos
hdfs dfs -mkdir -p /user/hive/warehouse/usuarios
echo "Uploading data to HDFS..."
# Subir archivos AVRO a HDFS uno por uno
hdfs dfs -put /data/userdata/userdata1.avro /user/hive/warehouse/usuarios/
hdfs dfs -put /data/userdata/userdata2.avro /user/hive/warehouse/usuarios/
hdfs dfs -put /data/userdata/userdata3.avro /user/hive/warehouse/usuarios/
hdfs dfs -put /data/userdata/userdata4.avro /user/hive/warehouse/usuarios/
hdfs dfs -put /data/userdata/userdata5.avro /user/hive/warehouse/usuarios/
# Subir el esquema AVRO a HDFS
hdfs dfs -put /data/userdata/userdata.avsc /user/hive/warehouse/usuarios/
# Ajustar permisos
hdfs dfs -chmod -R 777 /user/hive/warehouse/usuarios
echo "✅ Datos AVRO y esquema cargados en HDFS correctamente."