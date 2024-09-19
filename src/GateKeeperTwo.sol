// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        console.log("Gate One : ", msg.sender);
        console.log("Gate One : ", tx.origin);

        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }

        console.log("Gate Two : ", x);

        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        console.log("Gate Three : ", uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))));
        console.log("Gate Three : ", uint64(_gateKey));
        console.log("Gate Three : ", uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey));
        console.log("Gate Three : ", type(uint64).max);

        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}