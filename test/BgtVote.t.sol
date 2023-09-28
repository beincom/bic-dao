// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../src/token/BeinGiveTake.sol";
import "../src/vote/BgtVote.sol";
import "forge-std/Test.sol";

contract BgtVoteTest is Test {
    BeinGiveTake public bgt;
    BgtVote public bgtVote;
    uint256 public user1PKey = 0x1;
    address public user1 = vm.addr(user1PKey);
    uint256 public user2PKey = 0x2;
    address public user2 = vm.addr(user2PKey);
    uint256 public user3PKey = 0x3;
    address public user3 = vm.addr(user3PKey);
    uint256 public user4PKey = 0x4;
    address public user4 = vm.addr(user4PKey);

    function setUp() public {
        vm.prank(user1);
        bgt = new BeinGiveTake();
        bgtVote = new BgtVote();
    }

    function testVote() public {
        address[] memory targets = new address[](1);
        targets[0] = address(bgt);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory callDatas = new bytes[](1);
        callDatas[0] = abi.encodeWithSignature("mint(address,uint256)", user1, 100);
        uint256 proposeId = bgtVote.propose(targets, values, callDatas, "Lets mint 100 BGT for user1");
        assertEq(uint(bgtVote.state(proposeId)), 0);

        vm.roll(block.number + 5 + 1);
        assertEq(uint(bgtVote.state(proposeId)), 1);

        vm.prank(user1);
        bgtVote.castVote(proposeId, 1);
        vm.prank(user2);
        bgtVote.castVote(proposeId, 1);
        vm.prank(user3);
        bgtVote.castVote(proposeId, 1);
        vm.prank(user4);
        bgtVote.castVote(proposeId, 0);

        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = bgtVote.proposalVotes(proposeId);
        assertEq(againstVotes, 100);
        assertEq(forVotes, 300);
        assertEq(abstainVotes, 0);

        vm.roll(block.number + 50 + 1);
        assertEq(uint(bgtVote.state(proposeId)), 2);

//        vm.prank(user1);
//        bgtVote.execute(proposeId);
//        assertEq(bgt.balanceOf(user1), 100);
//        assertEq(bgt.totalSupply(), 100);
    }

}
