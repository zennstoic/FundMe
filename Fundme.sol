// SPDX-License-Identifier: MIT


pragma solidity ^0.8.2;

import {AggregatorV3Interface} from "@chainlink/contracts@1.4.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

    // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia Test-Net

contract Fundme {

    AggregatorV3Interface internal pricefeed;

    uint256 minimumUSD = 2e8;

    address[] funders;
    mapping(address funder => uint256 amountsent) addressToAmountSent;

    constructor(){
        pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }


    function fund() public payable {
        (,int256 answer,,,) = pricefeed.latestRoundData();
        uint256 ethValueInUSD = (msg.value * uint256(answer)) / 1e18;
        require(ethValueInUSD >= minimumUSD, "Not Enough ETH!");
        funders.push(msg.sender);
        addressToAmountSent[msg.sender] += msg.value;
    }



    function getPrice() view public returns(uint256) {
        (,int256 answer,,,) = pricefeed.latestRoundData();
        require(answer > 0, "ChainLink Error");
        return uint256(answer / 1e8);
    }

}