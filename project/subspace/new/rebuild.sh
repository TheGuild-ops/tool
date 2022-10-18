#!/bin/bash
NUM=${1}
VERSION=${2}
MONIKER=${3}
PLOT_SIZE=${4}

function portAssign {
 port=$((10000 + $RANDOM % 100000))
  if [  $(ss -lntu | grep -q $port) ]; then
   echo $port
   portAssign
  else
 echo $port
fi
}


pp2p=$(portAssign)
prpc=$(portAssign)
pws=$(portAssign)
ufw  insert 1 allow in $pp2p
ufw  insert 1 allow $prpc
ufw  insert 1 allow $pws

cat << EOF > docker-compose.yaml
version: "3.7"
services:
  node:
    image: ghcr.io/subspace/node:gemini-$VERSION
    volumes:
      - ./data:/db
    ulimits:
      nproc: 65535
      nofile:
        soft: 26677
        hard: 46677
    ports:
      - "0.0.0.0:$pp2p:$pp2p"
      - "0.0.0.0:$prpc:$prpc"
      - "0.0.0.0:$pws:$pws"
    restart: unless-stopped
    command: [
      "--chain", "gemini-2a",
      "--base-path", "/db",
      "--execution", "wasm",
      "--pruning", "1024",
      "--keep-blocks", "1024",
      "--port", "$pp2p",
      "--ws-port", "$pws",
      "--rpc-port", "$prpc",
      "--rpc-cors", "all",
      "--rpc-methods", "safe",
      "--unsafe-ws-external",
      "--validator",
      "--name", "$MONIKER"
    ]
    healthcheck:
      timeout: 5s
      interval: 30s
      retries: 5
EOF

tmp="volumes:\n   node-data:"
for (( i=0; i <= $NUM; i++ ))
do

touch ./keyLast.json
adress=$(cat ./keyLast.json | jq .[$i].adress)
if [ "$adress" = "null" ]
 then
   
 fi

adress=$(cat ./keyLast.json | jq .[$i].adress)

if [ "$adress" != "null" ]
 then
  echo '  farmer-'$i':'>> docker-compose.yaml
  echo '    image: ghcr.io/subspace/farmer:gemini-'$VERSION >> docker-compose.yaml
  echo '    ulimits: '>> docker-compose.yaml
  echo '       nproc: 65535 '>> docker-compose.yaml
  echo '       nofile: '>> docker-compose.yaml
  echo '         soft: 26677 '>> docker-compose.yaml
  echo '         hard: 46677 '>> docker-compose.yaml
  echo '    volumes: '>> docker-compose.yaml
  echo '      - ./data-'$i':/db '>> docker-compose.yaml
  echo '    restart: unless-stopped '>> docker-compose.yaml
  echo '    command: [ '>> docker-compose.yaml
  echo '      "--base-path", "/db/farmer", '>> docker-compose.yaml
  echo '      "farm", '>> docker-compose.yaml
  echo '      "--node-rpc-url", "ws://node:'$pws'", '>> docker-compose.yaml
  echo '      "--ws-server-listen-addr", "0.0.0.0:'$prpc'", '>> docker-compose.yaml
  echo '      "--reward-address", '$adress', '>> docker-compose.yaml
  echo '      "--plot-size", "'$PLOT_SIZE'" '>> docker-compose.yaml
  echo '   ] '>> docker-compose.yaml
  tmp="$tmp\n  farmer-$i-data:"
fi
done
echo -e $tmp >> docker-compose.yaml
