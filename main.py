from pyhive import hive
import mysql.connector
from hdfs import InsecureClient

# Conexión a HDFS
hdfs_client = InsecureClient('http://namenode:9870', user='hadoop')

# Leer los datos de HDFS
print("Leyendo datos desde HDFS...")
with hdfs_client.read('/user/hive/summary/000000_0') as reader:
    data = reader.read().decode('utf-8').splitlines()

# Procesar los datos
print("Procesando datos...")
summary_data = [line.split('\t') for line in data]  # Ajusta según el formato de los datos

# Conexión a MySQL
print("Conectando a MySQL...")
conn_mysql = mysql.connector.connect(
    host="mysql",
    user="mysql_user",
    password="grafana",
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
for country, user_count in summary_data:
    cursor_mysql.execute("INSERT INTO summary (country, user_count) VALUES (%s, %s)", (country, int(user_count)))

# Confirmar los cambios
conn_mysql.commit()
print("Datos volcados exitosamente en MySQL.")

# Cerrar las conexiones
cursor_mysql.close()
conn_mysql.close()