from pyhive import hive
import mysql.connector
from hdfs import InsecureClient
import re
import csv
import io

# Conexión a HDFS
hdfs_client = InsecureClient('http://namenode:9870', user='hadoop')
# Lo conmentado es de la versión de hive
# print("Leyendo datos desde HDFS en formato CSV...")
# with hdfs_client.read('/user/hive/summary/000000_0', encoding='utf-8') as reader:
#     csv_data = reader.read()
# Leer el archivo CSV desde HDFS
print("Leyendo datos desde HDFS en formato CSV...")
with hdfs_client.read('/user/impala/summary/9a45d1554556c7ef-df99997100000001_187404063_data.0.txt', encoding='utf-8') as reader:
    csv_data = reader.read()

# Procesar CSV
summary_data = []
csv_reader = csv.reader(io.StringIO(csv_data))

for row in csv_reader:
    # Verificar que haya al menos dos columnas
    if len(row) >= 2:
        country = row[0].strip()
        user_count_str = row[1].strip()

        # Limpiar el nombre del país
        country = re.sub(r'[^a-zA-Z0-9\s,]', '', country)

        # Convertir el conteo de usuarios a entero
        try:
            user_count = int(user_count_str)
            summary_data.append((country, user_count))
        except ValueError:
            print(f"Skipping row due to invalid user_count value: {user_count_str}")
    else:
        print(f"Skipping row with insufficient data: {row}")

# Conexión a MySQL
print("Conectando a MySQL...")
conn_mysql = mysql.connector.connect(
    host="mysql",
    user="root",
    password="root",
    database="hive_summary"
)
cursor_mysql = conn_mysql.cursor()

# Crear la tabla summary en MySQL si no existe
print("Creando tabla summary en MySQL...")
cursor_mysql.execute("""
    CREATE TABLE IF NOT EXISTS summary (
        country VARCHAR(255),
        user_count BIGINT
    )
""")

# Insertar los datos en MySQL
print("Insertando datos en MySQL...")
for row in summary_data:
    cursor_mysql.execute("INSERT INTO summary (country, user_count) VALUES (%s, %s)", row)

# Confirmar los cambios
conn_mysql.commit()
print("Datos volcados exitosamente en MySQL.")

# Cerrar las conexiones
cursor_mysql.close()
conn_mysql.close()