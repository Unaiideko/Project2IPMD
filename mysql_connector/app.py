import mysql.connector

# Conectar a MySQL
try:
    mysql_conn = mysql.connector.connect(
        host="mysql",
        user="root",  # Asegúrate de cambiar esto
        password="root",  # Asegúrate de cambiar esto
        database="hive_summary"  # Asegúrate de cambiar esto
    )
    cursor_mysql = mysql_conn.cursor()
    print("✅ Conexión a MySQL establecida correctamente.")
except Exception as e:
    print(f"❌ Error conectando a MySQL: {e}")
    exit(1)

# Insertar datos en MySQL (evitando duplicados)
cursor_mysql.execute("SELECT country, user_count FROM datos;")

# Insertar datos en la tabla (evitando duplicados)
for row in cursor_mysql.fetchall():
    cursor_mysql.execute("""
        INSERT INTO datos (country, user_count)
        VALUES (%s, %s)
        ON DUPLICATE KEY UPDATE user_count = VALUES(user_count)
    """, row)

# Confirmar cambios
mysql_conn.commit()
print("✅ Datos exportados correctamente a MySQL.")

# Cerrar conexiones
cursor_mysql.close()
mysql_conn.close()

# Salimos del script
exit(0)
