#!/bin/bash

https://docs.soliditylang.org/en/v0.8.13/internals/layout_in_storage.html#storage-hashed-encoding

cast storage $PRIVACY --rpc-url $RINKERBY 5

cast send $PRIVACY --rpc-url $RINKERBY --private-key $PRIVATE_KEY "unlock(bytes16 _key)" 0x08f99efe07ce4fbea4eee5523a0e5d66
