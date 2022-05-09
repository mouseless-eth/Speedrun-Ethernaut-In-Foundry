## Recovery Level Outline

**Difficulty : 6/10**

A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. After deploying the first token contract, the creator sent 0.5 ether to obtain more tokens. They have since lost the contract address.

This level will be completed if you can recover (or remove) the 0.5 ether from the lost contract address.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Recovery {

  //generate tokens
  function generateToken(string memory _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}

contract SimpleToken {

  using SafeMath for uint256;
  // public variables
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) public {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value.mul(10);
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x0EB8e4771ABA41B70d0cb6770e04086E5aee5aB2)

## Solution

Contract addresses are created in a determinalistic way, we can reverse engineer the address or we could just check etherscan.

### Walkthrough
##### 1. Find the address of the contract using etherscan by checking internal txs of the level instance creation transaction

```
https://rinkeby.etherscan.io
```

##### 2. Call the `destory()` function to retrieve the lost funds
```console
cast send $LOST_CONTRACT_ADDRESS "destroy(address)" $YOUR_ADDRESS --private-key $PRIVATE_KEY
```

## Further Reading
[create2](https://blog.smartdec.net/how-to-define-smart-contract-address-before-the-deploy-create2-use-case-for-decentralized-exchange-52b7daa7873b) code to define contract address before deploying

Contract addresses are deterministic and are calculated by keccack256(address, nonce) where the address is the address of the contract (or ethereum address that created the transaction) and nonce is the number of contracts the spawning contract has created (or the transaction nonce, for regular transactions).

Because of this, one can send ether to a pre-determined address (which has no private key) and later create a contract at that address which recovers the ether. This is a non-intuitive and somewhat secretive way to (dangerously) store ether without holding a private key.

[More info about the above example here](martin.swende.se/blog/Ethereum_quirks_and_vulns.html)


---

##### [:arrow_left: Back To Main Menu](../README.md)
