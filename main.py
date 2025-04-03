from pyhive import hive
import mysql.connector

# Conexión a Hive
conn_hive = hive.Connection(host='hive_host', port=10000, username='hive_user', database='default')
cursor_hive = conn_hive.cursor()
cursor_hive.execute("SELECT * FROM summary")

# Conexión a MySQL
conn_mysql = mysql.connector.connect(
    host="mysql_host",
    user="mysql_user",
    password="mysql_password",
    database="mysql_database"
)
cursor_mysql = conn_mysql.cursor()

# Insertar los datos en MySQL
for row in cursor_hive.fetchall():
    pais, numero_usuarios = row
    cursor_mysql.execute("INSERT INTO summary (pais, numero_usuarios) VALUES (%s, %s)", (pais, numero_usuarios))

conn_mysql.commit()
cursor_hive.close()
cursor_mysql.close()
conn_hive.close()
conn_mysql.close()