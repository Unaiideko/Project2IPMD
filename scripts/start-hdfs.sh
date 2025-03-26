#!/bin/bash

# Iniciar el NameNode
$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode

# Iniciar los DataNodes
$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode

# Esperar para que los servicios se levanten
tail -f $HADOOP_HOME/logs/* 
