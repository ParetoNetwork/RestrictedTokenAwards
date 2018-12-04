# RestrictedTokenAwards
RTAs made to mimmick RSAs, for giving vesting agreements to partners

Restricted Token Awards are like Restricted Stock Awards. 

For use with employees this does not allow for arbitrary tax withholding from distributions.

#Steps

## Install project dependencies
`npm install`

## Change Beneficiary address
`Change beneficiary's address in migrations/2_deploy_RTU.js on line # 3`
`Set number months in migrations/2_deploy_RTU.js on line # 4`

## Change mnemonic
`Change mnemonic in truffle.js file`

## Deploy to Mainnet 
```
truffle migrate --network mainnet
```


### Note
After the contract is deployed and before the first month’s payout, fund the contract with the tokens.

