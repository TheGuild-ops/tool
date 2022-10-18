#!/bin/bash
PNAME=subspace
PPATH=$HOME/node/$PNAME
apt update && apt upgrade -y
apt autoremove -y
cd
mkdir $PPATH -p
cd $PPATH

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

if [[ -z $VERSION ]]
then
 VALIDATOR_NAME=2a-2022-oct-06
fi

if [[ -z $SUBSPACE_PLOT_SIZE ]]
then
 SUBSPACE_PLOT_SIZE=100G
fi

if [[ -z $SUBSPACE_REWARD_ADRESS ]]
then
  SUBSPACE_REWARD_ADRESS=""
fi

wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/project/subspace/new/cheack.js -O cheack.js
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/project/subspace/new/rebuild.sh -O rebuild.sh
wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/project/subspace/new/subspace_util.service -O /etc/systemd/system/subspace_util.service
chmod +x $PPATH/rebuild.sh

cat << EOF > $PPATH/run.sh
#!/bin/bash
bash $PPATH/cheack.js $COUNT $VERSION $VALIDATOR_NAME $SUBSPACE_PLOT_SIZE
node $PPATH/rebuild.js $COUNT

EOF

chmod +x $PPATH/run.sh

systemctl daemon-reload
systemctl enable subspace_util.service
systemctl stop subspace_util.service
systemctl start subspace_util.service
