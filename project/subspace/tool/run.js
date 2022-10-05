'use strict';
const { exec } = require('child_process');
const { ApiPromise, WsProvider } = require('@polkadot/api');
const wsProvider = new WsProvider('wss://subspace-gemini-2a-rpc.dwellir.com/');
const fs = require('fs');
(async () => {
  try {
    const rawdata = fs.readFileSync('/root/node/subspace/lastKey.json');
    const adress = JSON.parse(rawdata).adress;
    const api = await ApiPromise.create({ provider: wsProvider });
    const { nonce, data: balance } = await api.query.system.account(
      adress,
    );

    if (balance.free > 500000000000000000) {
      const yourscript = exec('bash update.sh', (error, stdout, stderr) => {
        console.log(stdout);
        console.log(stderr);
        if (error !== null) {
          console.log(`exec error: ${error}`);
        }

process.exit(-1);
      });
    }

  } catch (err) {
    console.log(err);
    return;
  }
  console.log("NotNow")
  process.exit(-1);
return;
})();
