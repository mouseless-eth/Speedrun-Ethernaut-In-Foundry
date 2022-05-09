## Magic Number Level Outline

> This level was completed using `etherjs` not foundry

**Difficulty : 6/10**

To solve this level, you only need to provide the Ethernaut with a Solver, a contract that responds to whatIsTheMeaningOfLife() with the right number.

Easy right? Well... there's a catch.

The solver's code needs to be really tiny. Really reaaaaaallly tiny. Like freakin' really really itty-bitty tiny: 10 opcodes at most.

Hint: Perhaps its time to leave the comfort of the Solidity compiler momentarily, and build this one by hand O_o. That's right: Raw EVM bytecode.

```solidity  
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract MagicNum {

  address public solver;

  constructor() public {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}
```

[Link to level on Ethernaut](https://ethernaut.openzeppelin.com/level/0x200d3d9Ac7bFd556057224e7aEB4161fED5608D0)

## Solution

To solve this problem we need 2 sets of opcodes.

- `Init opcodes` sets up (constructs) the contract and returns the runtime code to be stored on chain
- `Runtime opcodes` the code that the EVM evaluates when a cotnract on chain has been called.

Let's construct the contract using EVM bytecode and then creating a contract instance.

We will use [evm.codes](https://www.evm.codes/) to find the opcode values for each instruction

### Walkthrough

#### Part One : Formulating Runtime Code Logic
1. let's store the value `0x2A` (which is `42` in decimal) into memory slot `0x42` using the `MSTORE(p,v)` instruction. 
> where `p` is the position in memory and `v` is the value
```console
602A // push1 0x2A (value of v)
6042 // push1 0x42 (value of p)
52   // opcode for MSTORE 
```
> `push1` pushes variables to the stack. mstore will read the first two values on the stack and treat them as `v` and `p`

2. return the value that we stored at memory location `0x42`
```console
6020  // push1 0x20 (return value is 32 bytes in size)
6042  // push1 0x42 (location of in memory that we will return)
f3    // opcode for RETURN
```

3. this means that our full runtime code will look like the following 

```console
0x602A60425260206042f3    
```
> take note that this means our runtime bytecode is exactly 10 bytes in size

#### Part Two : Formulating Init Code Logic

1. the `init opcodes` need to copy your `runtime opcodes` to memory, before returning them to the EVM.

we can copy code by using the `CODECOPY` instruction which takes the following parameters
- `t` where to save the code in memory (to keep it simple we will save it to 0x0)
- `f` the current position of the `runtime opcodes` in reference to the entire bytecode. Think of `f` as starting where the `initialization opcodes` end
- `s` the size of the code we want to copy. In ourcase this value will be equal to 10 bytes or `0x0a` in hexadecimal

```console
600a  // push1 0x0a (10bytes)
600c  // push1 0x0c (relative position of runtime opcodes)
6000  // push1 0x0a (destination memory index 0)
39    // opcode for CODECOPY

600a  // push1 0x0a (runtime opcode length)
6000  // push1 0x00 (memory index 0)
f3    // opcode for RETURN TO EVM
```

this means our `init opcodes` will look like

```console
0x600a600c600039600a6000f3 
```

combinding our `init opcodes` and `runtime opcodes` yields :

```
0x600a600c600039600a6000f3602A60425260206042f3    
```
 
#### Part Three : Deploying Contract

##### 1. Let's create the contract from your browser console on Ethernaut - no idea how to do this step in foundry :( 

open your browser console and exectute the following

```console
web3.eth.defaultAccount = web3.eth.accounts[0];
var tx = {
  from: <your-eoa-address-here>,
  data : "0x600a600d600039600a6000f300602a60805260206080f3"
}
web3.eth.sendTransaction(tx, (err,res)=>{console.log(err,res);});
```

##### 2. Let's submit our new contract instance to the level
```console
cast send $LEVEL_ADDRESS "setSolver(address)" $DEPLOYED_ADDRESS --private-key $PRIVATE_KEY
``` 
> replace DEPLOYED_ADDRESS with the address of the deployed contract

## Further Reading
[Init and runtime contract bytecode](https://monokh.com/posts/ethereum-contract-creation-bytecode)
[EVM.codes](https://www.evm.codes/) - EVM opcode navigator

0xSage for their [walkthrough on this level](https://medium.com/coinmonks/ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes-c50edb0f71a2)

### [:arrow_left: Back To Main Menu](../README.md)
