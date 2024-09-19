// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/DoubleEntryPoint.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DetectionBot {
    address private cryptoVault;

    constructor(address _cryptoVault) public {
        cryptoVault = _cryptoVault;
    }
    
    function handleTransaction(address user, bytes calldata msgData) public {
        address origSender;

        assembly {
            origSender := calldataload(0xa8)
        }

        if(origSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}

contract DoubleEntryPointSolution is Script {
    DoubleEntryPoint public doubleEntryPoint = DoubleEntryPoint(0x165C057f37131aDF9426259E2133eFf10C550B00);
    Forta public forta = Forta(address(doubleEntryPoint.forta()));
    LegacyToken public legacyToken = LegacyToken(address(doubleEntryPoint.delegatedFrom()));
    CryptoVault public cryptoVault = CryptoVault(address(doubleEntryPoint.cryptoVault()));


    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", doubleEntryPoint.player());
        console.log("Before cryptoVault : ", doubleEntryPoint.balanceOf(doubleEntryPoint.cryptoVault()));
        console.log("Before Legacy : ", LegacyToken(doubleEntryPoint.delegatedFrom()).balanceOf(doubleEntryPoint.cryptoVault()));
        console.log("Delegated Contract : ", address(legacyToken.delegate()));

        DetectionBot detectionBot = new DetectionBot(address(doubleEntryPoint.cryptoVault()));

        forta.setDetectionBot(address(detectionBot));
        cryptoVault.sweepToken(legacyToken);
        
        console.log("After cryptoVault : ", doubleEntryPoint.balanceOf(doubleEntryPoint.cryptoVault()));
        console.log("After Legacy : ", LegacyToken(doubleEntryPoint.delegatedFrom()).balanceOf(doubleEntryPoint.cryptoVault()));

        vm.stopBroadcast();
    }
}