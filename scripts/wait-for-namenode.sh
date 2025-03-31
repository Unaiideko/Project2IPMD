#!/bin/bash
echo "Esperando al NameNode..."
MAX_ATTEMPTS=30
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT+1))
  echo "Intento $ATTEMPT de $MAX_ATTEMPTS..."
  
  # Intentar conectarse al NameNode
  nc -z namenode 8020 >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "¡Conexión establecida con el NameNode!"
    break
  fi
  
  echo "Esperando 5 segundos..."
  sleep 5
done

# Ejecutar el entrypoint original
exec /entrypoint.sh