#!/bin/bash

KEY=$(docker run parity/subkey:latest  generate --network subspace_testnet --output-type json)
echo $KEY >> key.json
echo "GG"
WALLET_ADDRESS=$(cat key.json | jq .ss58Address | tail -n -1)
echo { \"adress\" : "$WALLET_ADDRESS" } > keyLast.json
echo Change. New adress is $(cat keyLast.json)
PLOT_SIZE=100G
docker-compose down
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/project/subspace/docker-compose.yaml -O install && bash install moniker $WALLET_ADDRESS $PLOT_SIZE 2a-2022-sep-10 && rm install
cd /node/subspace/
docker-compose pull
docker-compose up -d
