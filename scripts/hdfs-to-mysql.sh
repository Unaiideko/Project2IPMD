#!/bin/bash
set -e

echo "Iniciando transferencia de datos de Hive a MySQL..."

# Exportar datos desde Hive a un archivo CSV temporal
beeline -u jdbc:hive2://hive:10000 << EOF
USE default;
INSERT OVERWRITE DIRECTORY '/tmp/country_data'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT 
  country,
  user_count,
  avg_salary,
  min_salary,
  max_salary
FROM summary;
EOF

# Verificar que los datos se hayan generado
hdfs dfs -ls /tmp/country_data

# Descargar datos al sistema de archivos local
rm -rf /tmp/country_data_local
mkdir -p /tmp/country_data_local
hdfs dfs -get /tmp/country_data/* /tmp/country_data_local/

# Crear tabla en MySQL e importar datos
mysql -h mysql -u root -proot << EOF
USE hive_summary;

DROP TABLE IF EXISTS country_summary;
CREATE TABLE country_summary (
  country VARCHAR(100),
  user_count INT,
  avg_salary FLOAT,
  min_salary FLOAT,
  max_salary FLOAT,
  PRIMARY KEY (country)
);

-- La tabla está lista para recibir datos
EOF

# Importar datos a MySQL
find /tmp/country_data_local -type f -name "*.csv" -o -name "000000_0" | while read file; do
  echo "Importando archivo: $file"
  mysql -h mysql -u root -proot hive_summary -e "
    LOAD DATA LOCAL INFILE '$file' 
    INTO TABLE country_summary 
    FIELDS TERMINATED BY ',' 
    LINES TERMINATED BY '\n'
    (country, user_count, avg_salary, min_salary, max_salary);"
done

echo "Transferencia de datos completada con éxito."
exit 0