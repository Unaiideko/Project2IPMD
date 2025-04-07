#!/usr/bin/env bash
cd "$(dirname "$0")"

docker build -t mysql_connector ../mysql_connector
docker run --name=ejecutor --network=mynet mysql_connector

# habría que comprobar que el comando se llega a ejecutar
docker stop ejecutor
docker rm ejecutor
docker image rm ejecutor