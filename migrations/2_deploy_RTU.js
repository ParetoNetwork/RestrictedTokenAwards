var RTU = artifacts.require("./RTU.sol");
// var token = artifacts.require("./DummyToken.sol");

const beneficiary = "0xB06cEF6B14dd249f5a0977F645436cC4f4095325"; // need to set real beneficiary here

module.exports = function(deployer, network, accounts) {
  // deployer.deploy(token, { from: accounts[0] }).then(() => { return
     deployer.deploy(RTU, beneficiary, 3, {
      from: accounts[0],
      value:web3.toWei('0.011','ether')
    })
  //   .then(async () => {
  //       const tokenInstance = await token.deployed();
  //       await tokenInstance.transfer(RTU.address, "100000000000000000000", {from:accounts[0]})
  //   })
  // });
};
