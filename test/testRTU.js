const token = artifacts.require("./DummyToken");
const RTU = artifacts.require("./RTU");

const beneficiary = "0xB06cEF6B14dd249f5a0977F645436cC4f4095325"; // need to set real beneficiary here

let flag = 0;
contract("Test RTU", (accounts) => {
    it("Testing RTU contract", async () => {
        const tokenInstance = await token.deployed();
        const RTUInstance = await RTU.deployed();

        return new Promise(async(resolve, reject) => {
            let id = setInterval(async () => {
                let balance = await tokenInstance.balanceOf(beneficiary);
                balance = balance.toNumber();
                const assertBalance1 = "60"+"0".repeat(18);
                if(balance == assertBalance1 && flag == 0){
                    flag = 1;
                    console.log("60 Tokens have been transferred");

                    await RTUInstance.makeManualPayment(4, {from:accounts[0]});
                }

                const assertBalance2 = "100"+"0".repeat(18);

                if(balance == assertBalance2){
                    console.log("100 Tokens have been transferred");
                    resolve();
                }
            
            }, 10000)
            
        })
    })
})