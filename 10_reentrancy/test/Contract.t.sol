// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Contract.sol";

contract ContractTest is Test {
    Attack private attack;
    address levelInstance = 0xB8da7ACE13a61Df1d87f0D470a57ADcf24d66972;

    // runs before every test
    function setUp() public {
        attack = new Attack(levelInstance);
    }

    function testAttack() public {
        attack.attack();
    }
}
