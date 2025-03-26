#!/bin/bash

# Iniciar el HDFS y YARN
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

# Iniciar HiveServer2
$HIVE_HOME/bin/hive --service hiveserver2 &
tail -f $HIVE_HOME/logs/*
