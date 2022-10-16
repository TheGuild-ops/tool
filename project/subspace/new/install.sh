#!/bin/bash

while getopts n:p:a:c: flag
do
    case "${flag}" in
        n) VALIDATOR_NAME=${OPTARG};;
        p) SUBSPACE_PLOT_SIZE=${OPTARG};;
        a) SUBSPACE_REWARD_ADRESS=${OPTARG};;
        c) COUNT=${OPTARG};;
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
mkdir $HOME/node/subspace -p
cd $HOME/node/subspace

echo "Validator name: $VALIDATOR_NAME";
echo "Plot Size: $SUBSPACE_PLOT_SIZE";
echo "Reward Adress: $SUBSPACE_REWARD_ADRESS";
