from pyhive import hive
import mysql.connector
from collections import Counter

# Conexión a Hive
print("Conectando a Hive...")
conn_hive = hive.Connection(host='hive_host', port=10000, username='hive_user', database='default')
cursor_hive = conn_hive.cursor()
cursor_hive.execute("SELECT country FROM usuarios")

# Procesar los datos en Python
print("Procesando datos desde Hive...")
countries = [row[0] for row in cursor_hive.fetchall()]
summary_data = Counter(countries).most_common(10)  # Obtener los 10 países con más usuarios

# Conexión a MySQL
print("Conectando a MySQL...")
conn_mysql = mysql.connector.connect(
    host="mysql_host",
    user="mysql_user",
    password="mysql_password",
    database="hive_summary"  # Asegúrate de que esta base de datos exista
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
    cursor_mysql.execute("INSERT INTO summary (country, user_count) VALUES (%s, %s)", (country, user_count))

# Confirmar los cambios
conn_mysql.commit()
print("Datos volcados exitosamente en MySQL.")

# Cerrar las conexiones
cursor_hive.close()
conn_hive.close()
cursor_mysql.close()
conn_mysql.close()