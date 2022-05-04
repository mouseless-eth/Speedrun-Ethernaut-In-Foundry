#!/bin/bash
for i in {1..10}
do
    cast send 0x211F1d8454f07C31251a55ee703D7c6F2EE6bc5C "predictFuture()" --gas 80000 --private-key $PRIVATE_KEY
    sleep 20s
    echo Correct Flips : $i
done
