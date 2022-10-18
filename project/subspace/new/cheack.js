'use strict';

const { ApiPromise, WsProvider } = require('@polkadot/api');
const { Keyring } = require('@polkadot/keyring');
const { mnemonicGenerate } = require('@polkadot/util-crypto');
const { log } = require('console');
const wsProvider = new WsProvider('wss://subspace-gemini-2a-rpc.dwellir.com/');
const fs = require('fs');

(async () => {
  try {
    const lastAddressRaw = fs.readFileSync(`./keyLast.json`);
    const lastAddress = JSON.parse(lastAddressRaw);
    const api = await ApiPromise.create({ provider: wsProvider });
    const start = Date.now();
    console.log(start);
    lastAddress.forEach(async (element) => {
      const { nonce, data: balance } = await api.query.system.account(
        element.adress,
      );

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

        let rawdata = fs.readFileSync('./key.json');
        const wallet = JSON.parse(rawdata);
        console.log(wallet);
        wallet.push({ mnemonic: mnemonic, address: pair.address });
        const dataWalelt = JSON.stringify(wallet);
        try {
          fs.writeFileSync('./key.json', dataWalelt);
          // file written successfully
        } catch (err) {
          console.error(err);
        }
        return (element.adress = pair.address);
      }
      const dataAddress = JSON.stringify(lastAddress);
      try {
        fs.writeFileSync('./keyLast.json', dataAddress);
        // file written successfully
      } catch (err) {
        console.error(err);
      }
    });

  } catch (err) {
    console.log(err);
    return;
  }
  process.exit(-1);
})();
