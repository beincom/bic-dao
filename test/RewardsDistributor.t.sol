// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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
        rewardsDistributor = new RewardsDistributor(address(token), 0x0);

        token.mintTo(address(rewardsDistributor), 1000);
    }

//    function testClaim() public {
//        bytes32[] memory merkleProof = new bytes32[](1);
//        merkleProof[0] = bytes32(0x0);
//        vm.prank(user1);
//        rewardsDistributor.claim(0, user1, 100, merkleProof);
//        uint256 user1Votes = token.balanceOf(user1);
//        assertEq(user1Votes, 100);
//    }
}
