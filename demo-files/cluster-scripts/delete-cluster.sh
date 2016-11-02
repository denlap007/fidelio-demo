#!/bin/bash
set -e

docker-machine rm -f node2 node1 node0 keystore &&
echo "Swarm cluster DELETED successfully"
