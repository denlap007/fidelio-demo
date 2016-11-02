#!/bin/bash
set -e

docker-machine start keystore &&
docker-machine start node0 &&
docker-machine start node1 &&
docker-machine start node2 &&
echo "Swarm Cluster STARTED successfully!"
