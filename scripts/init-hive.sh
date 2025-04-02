#!/bin/bash
# Crear el directorio .beeline si no existe
if [ ! -d "/home/hive/.beeline" ]; then
  mkdir -p /home/hive/.beeline
  chown hive:hive /home/hive/.beeline
  chmod 700 /home/hive/.beeline
fi

# Crear tabla en Hive y procesar datos
beeline -u jdbc:hive2://hive:10000 -e "
CREATE EXTERNAL TABLE usuarios
STORED AS AVRO
LOCATION 'hdfs://namenode:8020/user/hive/avro_data/'
TBLPROPERTIES ('avro.schema.url'='hdfs://namenode:8020/user/hive/avro_data/userdata.avsc');

CREATE EXTERNAL TABLE summary (
  country STRING,
  user_count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs://namenode:8020/user/hive/summary';

INSERT OVERWRITE TABLE summary
SELECT country, COUNT(*) AS user_count
FROM usuarios
GROUP BY country
ORDER BY user_count DESC;
"

echo "Procesamiento Hive completado"