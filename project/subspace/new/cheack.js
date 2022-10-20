'use strict';

const { ApiPromise, WsProvider } = require('@polkadot/api');
const { Keyring } = require('@polkadot/keyring');
const { mnemonicGenerate } = require('@polkadot/util-crypto');
const { log } = require('console');
const wsProvider = new WsProvider('wss://subspace-gemini-2a-rpc.dwellir.com/');
const fs = require('fs');

(async () => {
  try {
    const lastAddressRaw = fs.readFileSync(`keyLast.json`);
    const lastAddress = JSON.parse(lastAddressRaw);
    if (!fs.existsSync('keyS.json')) {
      fs.writeFile('keyS.json', '[]', (err) => {
        if (err) throw err;
        console.log('Data has been replaced!');
      });
    }
    const api = await ApiPromise.create({ provider: wsProvider });
    const start = Date.now();
    let i = 0;
    console.log(lastAddress);
    lastAddress.forEach(async (element) => {
      const { nonce, data: balance } = await api.query.system.account(
        element.adress,
      );
      console.log(parseInt(balance.free));
      if (parseInt(balance.free) > 500000000000000000) {
        console.log(parseInt(balance.free));
        const keyring = new Keyring({ type: 'sr25519', ss58Format: 2254 });
        const mnemonic = mnemonicGenerate();
        const pair = keyring.addFromUri(
          mnemonic,
          { name: 'first pair' },
          'sr25519',
          { ss58Format: 2254 },
        );

        let rawdata = fs.readFileSync('keyS.json', {
          encoding: 'utf8',
          flag: 'r',
        });
        const wallet = JSON.parse(rawdata);
        wallet.push({ mnemonic: mnemonic, address: pair.address });
        const dataWalelt = JSON.stringify(wallet);
        try {
          fs.writeFileSync('keyS.json', dataWalelt);
          // file written successfully
        } catch (err) {
          console.error(err);
        }
        element.adress = pair.address;
      }

      const dataAddress = JSON.stringify(lastAddress);
      try {
        fs.writeFileSync('keyLast.json', dataAddress);
        // file written successfully
      } catch (err) {
        console.error(err);
      }
      if (++i == lastAddress.length) process.exit(-1);
      return element;
    });
  } catch (err) {
    console.log(err);
  }
  //
})();
