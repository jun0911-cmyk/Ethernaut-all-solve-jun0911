// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperOne.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract GateKeeperOneTest is Test {
    address public origin = 0x709885C74934cC931562540A863A5659eb7Cbd49;

    event Log(string message);

    function setUp() public {
        vm.deal(address(this), 0);
    }

    function testGateThree() public {
        bytes8 convertAddress = 0x863A56590000bd49;

        require(uint32(uint64(convertAddress)) == uint16(uint64(convertAddress)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(convertAddress)) != uint64(convertAddress), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(convertAddress)) == uint16(uint160(origin)), "GatekeeperOne: invalid gateThree part three");

        emit Log("GatekeeperOne: gateThree success");
    }
}