-- Crear tabla externa con formato AVRO
CREATE EXTERNAL TABLE IF NOT EXISTS usuarios (
    id BIGINT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    ip_address STRING,
    cc BIGINT,
    country STRING,
    birthdate STRING,
    salary DOUBLE,
    title STRING,
    comments STRING
)
STORED AS AVRO
LOCATION 'hdfs:///user/hive/warehouse/usuarios'
TBLPROPERTIES ('avro.schema.url'='hdfs:///user/hive/warehouse/usuarios/userdata.avsc');

-- Crear tabla resumen de usuarios por país
CREATE TABLE IF NOT EXISTS summary AS
SELECT country, COUNT(*) AS user_count
FROM usuarios
GROUP BY country
ORDER BY user_count DESC
LIMIT 10;