## Naught Coin Level Outline

**Difficulty : 5/10**

NaughtCoin is an ERC20 token and you're already holding all of them. The catch is that you'll only be able to transfer them after a 10 year lockout period. Can you figure out how to get them out to another address so that you can transfer them freely? 

Complete this level by getting your token balance to 0.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

 contract NaughtCoin is ERC20 {

  // string public constant name = 'NaughtCoin';
  // string public constant symbol = '0x0';
  // uint public constant decimals = 18;
  uint public timeLock = now + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player) 
  ERC20('NaughtCoin', '0x0')
  public {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
    // _totalSupply = INITIAL_SUPPLY;
    // _balances[player] = INITIAL_SUPPLY;
    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }
  
  function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(now > timeLock);
      _;
    } else {
     _;
    }
  } 
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008)

## Solution

The contract inherits from [OpenZeppelin's ERC20 contract](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol) meaning that the level contract inherits all methods from `ERC20.sol`

`ERC20.sol` is an implementation of the IERC20 interface (ERC20 standard). The IERC20 interface has two transfer methods  

```solidity
function transfer(address to, uint256 amount) public returns (bool)
``` 
and 
```solidity
function transferFrom(address from, address to, uint256 amount) public returns (bool)
```

The level contract overrides the first transfer method but we can call the second transfer method which is inherited from OpenZeppelings ERC20.sol contract and untampered with.

The purpose of `transferFrom` is for other addresses (mainly smart contracts) to move tokens out of your address on your behalf. To allow an address to move any sum of tokens, we first need to **give it permission** by calling the `approve(address,uint256)` function which takes in the address that we allow to spend our tokens as well as the maximum number of tokens that the address can move. 

The `transferFrom` function seems unsafe at first but it is crucial for tasks such as making a swap on a defi protocol, selling your NFT without sending it to an escrow contract, 
> NFTs are not ERC20 but they have the same transferFrom and approve functions

### Walkthrough

##### 1. Approving our address to spend our tokens so that we can use the "transferFrom" function
```console
cast send $LEVEL_ADDRESS "approve(address,uint256)" 0x527B0642b3902C3Bc29ae13D8208b86dA007aa26 \
1000000000000000000000000 --private-key $PRIVATE_KEY
```

##### 2. Calling contract's "transferFrom(address from, address to, uint256 amount)" function to transfer all tokens to a burn address
```console
cast send $LEVEL_ADDRESS "transferFrom(address,address,uint256)" 0x527B0642b3902C3Bc29ae13D8208b86dA007aa26 \
0x000000000000000000000000000000000000dEaD 1000000000000000000000000 --private-key $PRIVATE_KEY
```
