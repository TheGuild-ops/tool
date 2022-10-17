#!/bin/bash
PNAME=subspace
PATH=$HOME/node/$PNAME

while getopts n:p:a:c:v: flag
do
    case "${flag}" in
        n) VALIDATOR_NAME=${OPTARG};;
        p) SUBSPACE_PLOT_SIZE=${OPTARG};;
        a) SUBSPACE_REWARD_ADRESS=${OPTARG};;
        c) COUNT=${OPTARG};;
        v) VERSION=${OPTARG};;
    esac
done

if [[ -z $VALIDATOR_NAME ]]
then
 VALIDATOR_NAME=moniker
fi

if [[ -z $SUBSPACE_PLOT_SIZE ]]
then
 SUBSPACE_PLOT_SIZE=100G
fi

if [[ -z $SUBSPACE_REWARD_ADRESS ]]
then
  SUBSPACE_REWARD_ADRESS=""
fi

if [[ -z $COUNT ]]
then
  echo "Enter farmer count"
  read COUNT
fi
apt update && apt update -y
cd
mkdir $PATH -p
cd $PATH
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/project/subspace/new/cheack.js -O cheack.js
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/project/subspace/new/rebuild.sh -O rebuild.sh

docker-compose down
##node $PATH/cheack.js
bash $PATH/rebuild.sh COUNT VERSION VALIDATOR_NAME SUBSPACE_PLOT_SIZE
##docker-compose up -d


echo "Validator name: $VALIDATOR_NAME";
echo "Plot Size: $SUBSPACE_PLOT_SIZE";
echo "Reward Adress: $SUBSPACE_REWARD_ADRESS";
