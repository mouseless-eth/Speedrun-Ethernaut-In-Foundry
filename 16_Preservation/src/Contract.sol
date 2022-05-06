// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Contract {
    uint256 storageSlot0;
    uint256 storageSlot1;
    uint256 attack_this_slot;

    function setTime(uint256 newOwner) public {
        attack_this_slot = newOwner;
    }
}
