var RTU = artifacts.require("./RTU.sol");

const beneficiary = "0xB06cEF6B14dd249f5a0977F645436cC4f4095325"; // need to set real beneficiary here

module.exports = function(deployer, network, accounts) {
  deployer.deploy(RTU, beneficiary, { from: accounts[0] });
};
