#!/bin/bash

# Inspecting the contract storage 
cast storage $VAULT --rpc-url $RINKERBY 1

# Turning our hex output to utf8
cast --to-ascii 0x412076657279207374726f6e67207365637265742070617373776f7264203a29

# Calling the unlock function with the password ;)
cast send $VAULT --rpc-url $RINKERBY --private-key $PRIVATE_KEY "unlock(bytes32 _password)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
