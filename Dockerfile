FROM bde2020/hive:2.3.2-postgresql-metastore

# Copiar scripts (sin tratar de instalar paquetes adicionales)
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Mantener el entrypoint original
ENTRYPOINT ["/entrypoint.sh"]