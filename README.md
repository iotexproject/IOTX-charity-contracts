# IOTX-charity-contracts

This is the set of contracts that are used for IoTeX's charity program.

## Development
```
npm install -g truffle
truffle develop
truffle(develop)> compile
```

## Test
```
truffle develop
truffle(develop)> migrate --reset
truffle(develop)> test

Using network 'develop'.
  Contract: Donate
    ✓ should accept donations from whitelisted donors until it reaches maximum (428ms)
    ✓ should fail to accept donations to a stranger
    ✓ should fail to accept donations since it is too much
    ✓ should fail to accept donations since it is too little
    ✓ should fail to accept donations if the contract is paused (98ms)
    ✓ should correctly report whitelisted addresses (75ms)
  6 passing (1s)
```

## Deploy
```
truffle compile
truffle migrate --network kovan
```
