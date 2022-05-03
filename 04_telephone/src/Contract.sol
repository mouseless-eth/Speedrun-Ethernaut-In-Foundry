// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Phone {
    Telephone telephone;

    constructor(address _telephoneAddr) {
       telephone = Telephone(_telephoneAddr);
    } 

    function changeOwner() public {
        telephone.changeOwner(msg.sender);
    }
}

interface Telephone {
    function changeOwner(address _owner) external;
}
