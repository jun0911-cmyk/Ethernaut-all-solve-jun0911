// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/MagicNum.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MagicNumSolution is Script {
    MagicNum public magicNum = MagicNum(0xb375a7D0Ea9D628210EF180b1AEEe725c7B1753B);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before solver : ", magicNum.solver());

        magicNum.setSolver(address(0x9Aa4C07a06961924818103039E2CF568E391EEDa));

        console.log("After solver : ", magicNum.solver());

        vm.stopBroadcast();
    }
}