// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Vault.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract VaultSolution is Script {
    Vault public valutInstance = Vault(0x18C37aEdd00cB48adb91a02085F09E7a672e2307);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("before locked : ", valutInstance.locked());

        valutInstance.unlock(0x412076657279207374726f6e67207365637265742070617373776f7264203a29);

        console.log("after locked : ", valutInstance.locked());

        vm.stopBroadcast();
    }
}