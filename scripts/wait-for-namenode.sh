#!/bin/bash
echo "Esperando al NameNode..."
MAX_ATTEMPTS=30
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT+1))
  echo "Intento $ATTEMPT de $MAX_ATTEMPTS..."
  
  # Verificar si el NameNode está disponible
  if timeout 1 bash -c "</dev/tcp/namenode/8020" 2>/dev/null; then
    echo "¡Conexión establecida con el NameNode!"
    break
  fi
  
  echo "Esperando 5 segundos..."
  sleep 5
done

# Ejecutar el datanode
exec hdfs datanode