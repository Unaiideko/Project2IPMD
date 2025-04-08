#!/bin/bash
# filepath: c:\Users\Ruben\Desktop\Inteligencia artificial\IPMD\Project2IPMD\scripts\init-hdfs.sh

# Crear directorio en HDFS para los datos de usuarios
hdfs dfs -mkdir -p /user/hive/warehouse/usuarios

# Subir los archivos AVRO al directorio de HDFS
hdfs dfs -put /data/userdata/*.avro /user/hive/warehouse/usuarios/

# Crear directorio en HDFS para el esquema AVRO
hdfs dfs -mkdir -p /user/hive/schemas

# Subir el archivo userdata.avsc al directorio de esquemas en HDFS
hdfs dfs -put /scripts/userdata.avsc /user/hive/schemas/

# Crear directorio en HDFS para la tabla summary
hdfs dfs -mkdir -p /user/hive/summary

# Asignar permisos adecuados a los directorios
hdfs dfs -chmod -R 777 /user/hive/warehouse/usuarios
hdfs dfs -chmod -R 777 /user/hive/schemas
hdfs dfs -chmod -R 777 /user/hive/summary

# Verificar que los archivos y directorios se hayan creado correctamente
echo "Archivos en /user/hive/warehouse/usuarios:"
hdfs dfs -ls /user/hive/warehouse/usuarios

echo "Archivos en /user/hive/schemas:"
hdfs dfs -ls /user/hive/schemas

echo "Directorio para summary en /user/hive/summary:"
hdfs dfs -ls /user/hive/summary