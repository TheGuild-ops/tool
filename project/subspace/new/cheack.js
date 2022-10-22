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
    const api = await ApiPromise.create({ provider: wsProvider });
    const start = Date.now();
    let i = 0;
    console.log(lastAddress);
    lastAddress.forEach(async (element) => {
      const { nonce, data: balance } = await api.query.system.account(
        element.adress,
      );
      console.log(parseInt(balance.free));
      if (parseInt(balance.free) >= 500000000000000000) {
        console.log(parseInt(balance.free));
        const keyring = new Keyring({ type: 'sr25519', ss58Format: 2254 });
        const mnemonic = mnemonicGenerate();
        const pair = keyring.addFromUri(
          mnemonic,
          { name: 'first pair' },
          'sr25519',
          { ss58Format: 2254 },
        );

        const dataWalelt = JSON.stringify({
          mnemonic: mnemonic,
          address: pair.address,
        });

        try {
          fs.writeFileSync('keyAll.json', dataWalelt, { flag: 'a+' });
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
