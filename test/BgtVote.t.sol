// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../src/token/BeinGiveTake.sol";
import "../src/governance/BgtVote.sol";
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
    uint256 public user5PKey = 0x5;
    address public user5 = vm.addr(user5PKey);

    function setUp() public {
        bgt = new BeinGiveTake();
        bgtVote = new BgtVote(address(bgt));

        bgt.mintTo(user1, 1000);
        bgt.mintTo(user2, 2000);
        bgt.mintTo(user3, 3000);
        bgt.mintTo(user4, 4000);

        bgt.grantRole(bgt.MINT_ROLE(), address(bgtVote));
    }

    function testVote() public {
        uint256 user1Votes = bgtVote.getVotes(user1);
        assertEq(user1Votes, 0);
        vm.prank(user1);
        bgtVote.delegate(user1);
        user1Votes = bgtVote.getVotes(user1);
        assertEq(user1Votes, 1000);

        vm.roll(block.number + 1); // delegate active after 1 block

        address[] memory targets = new address[](1);
        targets[0] = address(bgt);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory callDatas = new bytes[](1);
        callDatas[0] = abi.encodeWithSignature("mintTo(address,uint256)", user5, 100);
        vm.prank(user1);
        uint256 proposeId = bgtVote.propose(targets, values, callDatas, "Lets mint 100 BGT for user5");
        assertEq(uint(bgtVote.state(proposeId)), 0);

        vm.prank(user2);
        bgtVote.delegate(user1);
        vm.prank(user3);
        bgtVote.delegate(user3);
        vm.prank(user4);
        bgtVote.delegate(user4);

        vm.roll(block.number + 5 + 1);
        assertEq(uint(bgtVote.state(proposeId)), 1);

        assertEq(bgtVote.getVotes(user1), 3000);

        vm.prank(user1);
        bgtVote.castVote(proposeId, 1);
        vm.prank(user2);
        bgtVote.castVote(proposeId, 1);  // no effect
        vm.prank(user3);
        bgtVote.castVote(proposeId, 1);
        vm.prank(user4);
        bgtVote.castVote(proposeId, 0);

        vm.roll(block.number + 1);

        assertEq(bgtVote.getVotes(user1), 3000);
        bgt.mintTo(user1, 100);
        bgt.mintTo(user2, 200);

        vm.roll(block.number + 1);

        assertEq(bgtVote.getVotes(user1), 3000);

        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = bgtVote.proposalVotes(proposeId);
        assertEq(againstVotes, 4000);
        assertEq(forVotes, 6000);
        assertEq(abstainVotes, 0);

        vm.roll(block.number + 50 + 1);
        assertEq(uint(bgtVote.state(proposeId)), 4); // succeeded

        vm.prank(user1);
        bgtVote.execute(targets, values, callDatas, keccak256(bytes("Lets mint 100 BGT for user5")));
        assertEq(bgt.balanceOf(user5), 100);
    }

}
