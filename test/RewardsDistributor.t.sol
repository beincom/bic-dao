// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/token/TokenVote.sol";
import "forge-std/Test.sol";
import "../src/reward/RewardDistributior.sol";

contract RewardsDistributorTest is Test {
    TokenVote public token;
    RewardsDistributor public rewardsDistributor;
    uint256 public user1PKey = 0x1;
    address public user1 = vm.addr(user1PKey);
    uint256 public user2PKey = 0x2;
    address public user2 = vm.addr(user2PKey);
    uint256 public user3PKey = 0x3;
    address public user3 = vm.addr(user3PKey);
    uint256 public user4PKey = 0x4;
    address public user4 = vm.addr(user4PKey);
    uint256 public user5PKey = 0x5;
    address public user5 = vm.addr(user5PKey);

    function setUp() public {
        token = new TokenVote();
        string[] memory inputs = new string[](5);

        inputs[0] = "node";
        inputs[1] = "scripts/generateRoot.ts";

        bytes memory result = vm.ffi(inputs);
        // revert();
        bytes32 root = abi.decode(result, (bytes32));
        rewardsDistributor = new RewardsDistributor(address(token), root);

        token.mintTo(address(rewardsDistributor), 10000);
    }

    function testClaim() public {

        string[] memory inputs = new string[](5);

        inputs[0] = "node";
        inputs[1] = "scripts/getProof.ts";
        bytes memory result = vm.ffi(inputs);
        bytes32[] memory proofs = abi.decode(result, (bytes32[]));

        rewardsDistributor.claim(0, 0x92Bb439374a091c7507bE100183d8D1Ed2c9dAD3, 1000, proofs); // anyone can claim if they have the proof for the owner
        uint256 user1Votes = token.balanceOf(0x92Bb439374a091c7507bE100183d8D1Ed2c9dAD3);
        assertEq(user1Votes, 1000);

        vm.prank(0x92Bb439374a091c7507bE100183d8D1Ed2c9dAD3);
        vm.expectRevert("RewardsDistributor: Drop already claimed.");
        rewardsDistributor.claim(0, 0x92Bb439374a091c7507bE100183d8D1Ed2c9dAD3, 1000, proofs);

    }
}
