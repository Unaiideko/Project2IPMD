#!/bin/bash
echo "Configurando core-site.xml con la dirección correcta de namenode"
cat > /opt/hadoop/etc/hadoop/core-site.xml << EOF
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://namenode:8020</value>
  </property>
</configuration>
EOF