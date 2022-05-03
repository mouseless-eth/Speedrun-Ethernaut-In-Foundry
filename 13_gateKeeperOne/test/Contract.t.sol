// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Contract.sol";

contract ContractTest is Test {
    Attack attack;

    function setUp() public {
        attack = new Attack(0x1a67C1f381bA662Dd6853C276c14B7Df6d2930e5);
    }

    function testEnter() public {
        attack.enter(0x8208b86dA007aa26);
    }
}
