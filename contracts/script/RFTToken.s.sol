// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Script, console } from "forge-std/Script.sol";
import { RFTToken } from "../src/day4/RFTToken.sol";

// forge script script/week4/day1/DeployNFTMarketV1.s.sol --rpc-url http://127.0.0.1:8545
contract RFTTokenScript is Script {
  function run() public returns (address) {
    vm.startBroadcast();
    RFTToken token = new RFTToken();
    vm.stopBroadcast();
    console.log("RFTToken address: ", address(token));
  }
}
