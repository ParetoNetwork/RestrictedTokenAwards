var RTU = artifacts.require("./RTU.sol");

const beneficiary = "0xB06cEF6B14dd249f5a0977F645436cC4f4095325"; // need to set real beneficiary here
const noOfMonths = 3;
const cost = "0.0040455" * noOfMonths;
const amount = web3.toWei(cost, "ether");
console.log(cost, amount);


module.exports = function(deployer, network, accounts) {
  deployer.deploy(RTU, beneficiary, noOfMonths, {
    from: accounts[0],
    value: amount
  });
};
