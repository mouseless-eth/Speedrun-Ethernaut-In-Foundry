#!/bin/sh

# Creating our re-entrancy attack contract
forge create --rpc-url $RINKERBY --private-key $PRIVATE_KEY src/Contract.sol:Attack --constructor-args $REENTRANCY --value 0.001ether --gas-limit 300000
