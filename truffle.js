var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic =
  "avocado armed also position solution total token maze deny neutral bless share";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(
          mnemonic,
          "https://rinkeby.infura.io/QWMgExFuGzhpu2jUr6Pq",
          0,
          9
        );
      },
      network_id: 4,
      gas: 4712388
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(
          mnemonic,
          "https://ropsten.infura.io/QWMgExFuGzhpu2jUr6Pq",
          0,
          9
        );
      },
      network_id: 3,
      gas: 4712388
    },
    mainnet: {
      provider: function() {
        return new HDWalletProvider(
          mnemonic,
          "https://internally-settling-racer.quiknode.io/b5d97fc4-1946-4411-87e1-c7d961fb0e8d/X2kLtRMEBbjEkSJCCK8hFA==/",
          0,
          9
        );
      },
      network_id: 1,
      gas: 4712388
    }
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
