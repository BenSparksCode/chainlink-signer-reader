// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import {AccessControlledOffchainAggregator} from "src/ChainlinkAggregatorPublicSigners.sol";

import {Test, console} from "forge-std/Test.sol";

contract GetChainlinkSignersTest is Test {

    // Result:
    // signers[0] = 0xb4DC896090D778acC910db4D31f23d3667Add7Db;
    // signers[1] = 0x1b178090f318c9Fd2322D52a5aC85ebBcE6Bf5E7;
    // signers[2] = 0xB69dC0CaD9c739220A941f3D1C013ffd4CE7Dd6C;
    // signers[3] = 0x8CACd95416d74702bccC9336Fc15F7dD0b533dDe;

    function test_getChainlinkSigners_ETHUSD_Sepolia() public {
        // set chain fork to sepolia
        vm.createSelectFork(vm.envString("SEPOLIA_RPC_URL"));
        console.log("Forked Sepolia at block: ", block.number);

        // get runtime bytecode of modified ChainlinkAggregator with public getSigners function
        bytes memory code = vm.getDeployedCode("ChainlinkAggregatorPublicSigners.sol:AccessControlledOffchainAggregator");

        // vm.etch modified bytecode at real Sepolia Chainlink ETH/USD Aggregator's address
        address aggregatorAddr = 0x719E22E3D4b690E5d96cCb40619180B5427F14AE;
        vm.etch(aggregatorAddr, code);

        // call getSigners function
        address[] memory signers = AccessControlledOffchainAggregator(aggregatorAddr).getSigners();

        // print signers
        for (uint i = 0; i < signers.length; i++) {
            console.log("signers[", i, "] =", signers[i]);
        }
    }
}
