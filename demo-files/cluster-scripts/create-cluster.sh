#!/bin/bash
set -e
# create keystore machine 
docker-machine create -d virtualbox keystore && 
# Set your local environment to the keystore machine.
eval "$(docker-machine env keystore)" && 
# Start a progrium/consul container running on the keystore machine. The client starts a progrium/consul image running in the keystore machine. The server is called consul and is listening on port 8500.
docker run -d \
     -p "8500:8500" \
     -h "consul" \
     --name consul-keystore \
     --restart=always \
     progrium/consul -server -bootstrap &&


 # create Swarm Master
 docker-machine create \
  -d virtualbox \
  --swarm --swarm-master \
  --swarm-discovery="consul://$(docker-machine ip keystore):8500" \
  --engine-opt="cluster-store=consul://$(docker-machine ip keystore):8500" \
  --engine-opt="cluster-advertise=eth1:2376" \
  node0 &&

 # Create another host and add it to the swarm cluster
docker-machine create -d virtualbox \
 --swarm \
 --swarm-discovery="consul://$(docker-machine ip keystore):8500" \
 --engine-opt="cluster-store=consul://$(docker-machine ip keystore):8500" \
 --engine-opt="cluster-advertise=eth1:2376" \
node1 &&

 # Create another host and add it to the swarm cluster
docker-machine create -d virtualbox \
 --swarm \
 --swarm-discovery="consul://$(docker-machine ip keystore):8500" \
 --engine-opt="cluster-store=consul://$(docker-machine ip keystore):8500" \
 --engine-opt="cluster-advertise=eth1:2376" \
node2 &&

echo "Swarm Cluster successfully created!"
