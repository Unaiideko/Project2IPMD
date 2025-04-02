#!/bin/bash
set -e

echo "Iniciando procesamiento de datos en Hive..."

# Conectar a Hive y ejecutar comandos SQL
beeline -u jdbc:hive2://hive:10000 << EOF
-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS default;
USE default;

-- Crear la tabla para los datos AVRO
DROP TABLE IF EXISTS usuarios;
CREATE EXTERNAL TABLE usuarios (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  gender STRING,
  ip_address STRING,
  cc STRING,
  country STRING,
  birthdate STRING,
  salary FLOAT,
  title STRING,
  comments STRING
)
STORED AS AVRO
LOCATION 'hdfs:///user/hive/avro_data/';

-- Crear tabla resumen por país
DROP TABLE IF EXISTS summary;
CREATE TABLE summary AS
SELECT 
  country,
  COUNT(*) AS user_count,
  AVG(salary) AS avg_salary,
  MIN(salary) AS min_salary,
  MAX(salary) AS max_salary
FROM usuarios
GROUP BY country;

-- Verificar resultados
SELECT * FROM summary LIMIT 10;
EOF

echo "Procesamiento de datos completado con éxito."
exit 0