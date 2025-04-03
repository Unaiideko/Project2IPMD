FROM apache/hive:3.1.3

# Establecer el directorio de trabajo
WORKDIR /Project2IPMD

# Establecer el usuario root para instalar paquetes
USER root

# Actualizar los paquetes y instalar Maven
RUN apt-get update && apt-get install -y \
    python3-pip \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Crear el directorio para .beeline y asignar permisos
RUN mkdir -p /home/hive/.beeline && chown hive:hive /home/hive/.beeline

# Cambiar al usuario Hive para copiar y trabajar con archivos de Hive
USER hive

# Copiar los scripts y archivos de datos al contenedor
COPY hive/init_hive.sql init_hive.sql
COPY userdata /app/userdata 

# Copiar el archivo pom.xml para instalar dependencias Maven
COPY hive/pom.xml /opt/hive/pom.xml

# Ejecutar Maven para instalar dependencias
RUN mvn clean install -f /opt/hive/pom.xml

# Añadir configuración adicional de Hive si es necesario
# ADD hive/hive-site.xml /opt/hive/conf/hive-site.xml

# Establecer el comando para ejecutar Beeline con la inicialización de SQL
CMD [ "beeline", "-u", "jdbc:hive2://localhost:10000/", "-f", "hive/init_hive.sql" ]
