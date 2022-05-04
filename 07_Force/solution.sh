# Creating our contract
forge create --rpc-url=$RINKERBY --private-key=$PRIVATE_KEY src/Contract.sol:Contract --constructor-args 0xdE646e0942F99048C6495BE171d70bf5A8AE023E

# Calling our explode function
cast send 0x6fee8188ca808cbb79e4f3c8564f0e5ea552487e --rpc-url $RINKERBY --private-key $PRIVATE_KEY "explode()" --value 0.001ether
