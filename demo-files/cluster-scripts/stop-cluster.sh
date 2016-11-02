#!/bin/bash
set -e

docker-machine stop node2 &&
docker-machine stop node1 &&
docker-machine stop node0 &&
docker-machine stop keystore &&
echo "Swarm Cluster STOPPED successfully!"
