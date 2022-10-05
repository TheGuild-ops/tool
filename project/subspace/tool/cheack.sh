#!/bin/bash
cd /root/node/subspace/
docker-compose down
docker-compose up -d
node cheack.js
