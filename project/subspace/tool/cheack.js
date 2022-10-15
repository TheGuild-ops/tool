'use strict';

const num = process.argv[2];
const { exec } = require('child_process');
const { ApiPromise, WsProvider } = require('@polkadot/api');
const wsProvider = new WsProvider('wss://subspace-gemini-2a-rpc.dwellir.com/');
const fs = require('fs');

(async () => {
  try {
    const rawdata = fs.readFileSync(`/root/node/subspace/${num}/keyLast.json`);
    const adress = JSON.parse(rawdata).adress;
    const api = await ApiPromise.create({ provider: wsProvider });
    const { nonce, data: balance } = await api.query.system.account(adress);
    console.log(parseInt(balance.free));
    if (parseInt(balance.free) > 500000000000000000) {
      console.log('work');
      const yourscript = exec(`wget https://raw.githubusercontent.com/TheGuild-ops/tool/main/project/subspace/tool/update.sh -O update.sh; bash update.sh ${num}`, (error, stdout, stderr) => {
        console.log(stdout);
        console.log(stderr);
        if (error !== null) {
          console.log(`exec error: ${error}`);
        }

        process.exit(-1);
      });
    } else {
      console.log(`NotNow`);
      process.exit(-1);
      return;
    }
  } catch (err) {
    console.log(err);
    return;
  }
})();

