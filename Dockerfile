# Imagen base de Hadoop
FROM openjdk:8-jdk-alpine

# Variables de entorno para Hadoop y Hive
ENV HADOOP_VERSION 3.3.1
ENV HIVE_VERSION 3.1.2
ENV HADOOP_HOME /opt/hadoop
ENV HIVE_HOME /opt/hive
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HIVE_HOME/bin

# Instalar dependencias
RUN apk add --no-cache \
    bash \
    wget \
    curl \
    git \
    && wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
    && tar -xvf hadoop-$HADOOP_VERSION.tar.gz -C /opt \
    && rm hadoop-$HADOOP_VERSION.tar.gz \
    && mv /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
    && wget https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz \
    && tar -xvf apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt \
    && rm apache-hive-$HIVE_VERSION-bin.tar.gz \
    && mv /opt/apache-hive-$HIVE_VERSION-bin /opt/hive

# Copiar archivos de configuración
COPY config/* $HADOOP_CONF_DIR/
COPY hive-config/hive-site.xml $HIVE_HOME/conf/

# Exponer puertos para HiveServer2
EXPOSE 10000

# Volumen para Hive
VOLUME ["/opt/hive/data"]

# Inicializar Hive y ejecutar HiveServer2
CMD ["/bin/bash", "-c", "start-dfs.sh && start-yarn.sh && hive --service hiveserver2"]
