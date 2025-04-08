#!/bin/bash
# filepath: c:\Users\Ruben\Desktop\Inteligencia artificial\IPMD\Project2IPMD\scripts\init-hdfs.sh

# Crear directorio en HDFS para los datos de usuarios
hdfs dfs -mkdir -p /user/impala/warehouse/usuarios

# Subir los archivos AVRO al directorio de HDFS
hdfs dfs -put /data/userdata/*.avro /user/impala/warehouse/usuarios/

# Crear directorio en HDFS para el esquema AVRO
hdfs dfs -mkdir -p /user/impala/schemas

# Subir el archivo userdata.avsc al directorio de esquemas en HDFS
hdfs dfs -put /scripts/userdata.avsc /user/impala/schemas/

# Crear directorio en HDFS para la tabla summary
hdfs dfs -mkdir -p /user/impala/summary

# Asignar permisos adecuados a los directorios
hdfs dfs -chmod -R 777 /user/impala/warehouse/usuarios
hdfs dfs -chmod -R 777 /user/impala/schemas
hdfs dfs -chmod -R 777 /user/impala/summary

# Verificar que los archivos y directorios se hayan creado correctamente
echo "Archivos en /user/impala/warehouse/usuarios:"
hdfs dfs -ls /user/impala/warehouse/usuarios

echo "Archivos en /user/impala/schemas:"
hdfs dfs -ls /user/impala/schemas

echo "Directorio para summary en /user/impala/summary:"
hdfs dfs -ls /user/impala/summary