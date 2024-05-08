// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {RenftMarket} from "../src/RenftMarket.sol";
import {S2NFT} from "../src/NFTFactory.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();

        // RenftMarket c = new RenftMarket();
        S2NFT c = new S2NFT("Open Sky","OSK","ipfs://QmbveAod8raJyhDJYJd3E4pAiXdMcVQn4GC3bejqesdobd/",888);

        console.log("Counter address:", address(c));
    }
}
