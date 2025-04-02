-- Verificar si el rol existe antes de crear
DO
$$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'hive') THEN
    CREATE USER hive WITH PASSWORD 'hive';
  END IF;
END
$$;

-- Otorgar privilegios (esto es idempotente)
ALTER USER hive WITH SUPERUSER;

-- Verificar si la base de datos existe antes de crear
DO
$$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'metastore') THEN
    CREATE DATABASE metastore;
  END IF;
END
$$;

-- Otorgar privilegios (esto es idempotente)
GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;