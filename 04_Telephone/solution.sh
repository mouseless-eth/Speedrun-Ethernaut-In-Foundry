#!/bin/bash

# Deploying the contract using forge
# args = address of instance contract
forge create --rpc-url=$RINKERBY --private-key=$PRIVATE_KEY src/Contract.sol:Phone --constructor-args 0x6d9EA05032CC187B3dbEAc0E28Bf1bDc1c6a8bAA

# Calling our deployed contract using cast
# addr = address of our deployed contract using forge
cast send --rpc-url=$RINKERBY --private-key=$PRIVATE_KEY 0xE2678F4098BA94f39fc0686347d2b88F79E7CE25 "changeOwner()"
