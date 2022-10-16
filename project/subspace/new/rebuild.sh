NUM=${1}
VERSION=${2}

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

EOF
