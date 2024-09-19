// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperTwo.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract AttackerContract {
    constructor (address _address) {
        GatekeeperTwo gatekeeperTwoInstance = GatekeeperTwo(_address);
        bytes8 gateKey =  0x0000000000;

        gatekeeperTwoInstance.enter(gateKey);
    }
}

contract GateKeeperTwoTest is Test {
    GatekeeperTwo public gateKeeperTwoInstance;

    function setUp() public {
        gateKeeperTwoInstance = new GatekeeperTwo();
    }

    function testEnter() public {
        console.log("Sender : ", msg.sender);
        console.log("Address : ", address(this));

        new AttackerContract(address(gateKeeperTwoInstance));

        console.log("GatekeeperTwo: enter success");
    }
}