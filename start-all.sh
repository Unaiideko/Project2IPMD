#!/bin/bash
set -e

echo "===== Iniciando el stack completo ====="

# Iniciar todos los servicios
echo "Iniciando contenedores..."
docker-compose up -d

# Convertir los finales de línea de los scripts
echo "Preparando scripts..."
docker exec namenode bash -c "sed -i 's/\r$//' /scripts/*.sh && chmod +x /scripts/*.sh"
docker exec hive bash -c "sed -i 's/\r$//' /scripts/*.sh && chmod +x /scripts/*.sh"

# Esperar a que los servicios estén disponibles
echo "Esperando a que los servicios estén disponibles (30s)..."
sleep 30

# Verificar que HDFS está funcionando
echo "Verificando HDFS..."
docker exec namenode hdfs dfsadmin -safemode get || true

# Inicializar HDFS
echo "Inicializando HDFS..."
docker exec namenode bash -c "/scripts/init-hdfs.sh"

# Verificar que los directorios se crearon correctamente
echo "Verificando estructura de directorios..."
docker exec namenode hdfs dfs -ls /

# Crear directorio beeline en Hive (con usuario root)
echo "Preparando entorno Hive..."
docker exec -u 0 hive bash -c "mkdir -p /home/hive/.beeline && chmod 777 /home/hive/.beeline"

# Esperar a que HiveServer2 esté disponible
echo "Esperando a que HiveServer2 esté disponible..."
for i in {1..30}; do
  if docker exec hive bash -c "beeline -u jdbc:hive2://localhost:10000 -e 'SHOW DATABASES;'" > /dev/null 2>&1; then
    echo "HiveServer2 está listo."
    break
  fi
  echo "Intentando conectar a HiveServer2 ($i/30)..."
  sleep 3
done

# Inicializar Hive
echo "Inicializando Hive..."
docker exec hive bash -c "/scripts/init-hive.sh"

# Transferir datos a MySQL
echo "Transferiendo datos a MySQL..."
docker exec hive bash -c "/scripts/hdfs-to-mysql.sh"

# Verificar que todo funciona
echo "Verificando datos en MySQL..."
docker exec mysql bash -c "mysql -u root -proot -e 'USE hive_summary; SELECT COUNT(*) FROM country_summary;'"

echo "===== Todo inicializado correctamente ====="
echo "Accede a Grafana en http://localhost:3000 (admin/admin)"