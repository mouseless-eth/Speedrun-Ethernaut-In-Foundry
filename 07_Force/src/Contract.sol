// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Contract {
    address payable target;

    constructor(address payable _target) {
        target = _target;
    }

    function explode() public payable {
        selfdestruct(target);
    }
}
