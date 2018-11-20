# RestrictedTokenAwards
RTAs made to mimmick RSAs, for giving vesting agreements to partners

Restricted Token Awards are like Restricted Stock Awards. 

For use with employees this does not allow for arbitrary tax withholding from distributions.

#Steps

## Change Beneficiary address
`Change beneficiary's address in migrations/2_deploy_RTU.js`

## Change mnemonic
`Change mnemonic in truffle.js file`

## Deploy to Mainnet 
```
truffle migrate --network mainnet
```
