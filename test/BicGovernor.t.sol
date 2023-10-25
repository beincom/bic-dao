// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../src/test/BeinGiveTake.sol";
import "../src/test/BeinChain.sol";
import "../src/governance/BicGovernor.sol";
import "../src/vote/BicPower.sol";
import "../src/governance/BicGovernor.sol";
import "forge-std/Test.sol";

contract BicGovernorTest is Test {
    BeinGiveTake public bgt;
    BeinChain public bic;
    BicPower public bicPower;
    BicGovernor public bicGovernor;

    uint256 initialVotingDelay = 60;
    uint256 initialVotingPeriod = 300;
    uint256 initialProposalThreshold = 100;

    uint256 public user1PKey = 0x1;
    address public user1 = vm.addr(user1PKey);
    uint256 public user2PKey = 0x2;
    address public user2 = vm.addr(user2PKey);
    uint256 public user3PKey = 0x3;
    address public user3 = vm.addr(user3PKey);

    function setUp() public {
        bgt = new BeinGiveTake();
        bic = new BeinChain();
        bicPower = new BicPower(address(bgt), address(bic));
        bicGovernor = new BicGovernor(address(bicPower), initialVotingDelay, initialVotingPeriod, initialProposalThreshold);

        bgt.mintTo(user1, 1000);
        bgt.mintTo(user2, 2000);
        bgt.mintTo(user3, 3000);

        bgt.grantRole(bgt.MINT_ROLE(), address(bicPower));
        bgt.grantRole(bgt.MINT_ROLE(), address(bicGovernor));
    }

    function testBlacklistGovernor() public {
        bic.blockAddress(user1);
        vm.prank(user1);
        vm.expectRevert("BIC: blacklisted");
        bicPower.delegate(user1);
        assertEq(bicPower.getVotes(user1), 0);

        bic.unblockAddress(user1);
        vm.prank(user1);
        bicPower.delegate(user1);
        assertEq(bicPower.getVotes(user1), 1000);

        vm.roll(block.number + 1);

        bic.blockAddress(user1);

        address[] memory targets = new address[](1);
        targets[0] = address(bgt);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory callDatas = new bytes[](1);
        callDatas[0] = abi.encodeWithSignature("mintTo(address,uint256)", user1, 100);
        vm.prank(user1);
        uint256 proposalId = bicGovernor.propose(targets, values, callDatas, "Lets mint 100 BGT for user1");

        assertEq(uint(bicGovernor.state(proposalId)), 0);

        vm.roll(block.number + initialVotingDelay + 1);

        assertEq(uint(bicGovernor.state(proposalId)), 1);

        vm.prank(user1);
        vm.expectRevert("BIC: blacklisted");
        bicGovernor.castVote(proposalId, 1);
    }

    function testGovernorFullFlow() public {
        assertEq(bicPower.getVotes(user1), 0);

        vm.prank(user1);
        bicPower.delegate(user1);
        assertEq(bicPower.getVotes(user1), 1000);

        vm.prank(user2);
        bicPower.delegate(user2);
        assertEq(bicPower.getVotes(user2), 2000);

        vm.prank(user3);
        bicPower.delegate(user1);
        assertEq(bicPower.getVotes(user1), 4000);

        vm.roll(block.number + 1);

        address[] memory targets = new address[](1);
        targets[0] = address(bgt);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory callDatas = new bytes[](1);
        callDatas[0] = abi.encodeWithSignature("mintTo(address,uint256)", user1, 100);
        vm.prank(user1);
        uint256 proposalId = bicGovernor.propose(targets, values, callDatas, "Lets mint 100 BGT for user1");

        assertEq(uint(bicGovernor.state(proposalId)), 0);

        vm.roll(block.number + initialVotingDelay + 1);

        assertEq(uint(bicGovernor.state(proposalId)), 1);

        vm.prank(user1);
        bicGovernor.castVote(proposalId, 1);
        vm.prank(user2);
        bicGovernor.castVote(proposalId, 0);

        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = bicGovernor.proposalVotes(proposalId);
        assertEq(againstVotes, 2000);
        assertEq(forVotes, 4000);
        assertEq(abstainVotes, 0);

        vm.roll(block.number + initialVotingPeriod + 1);

        assertEq(uint(bicGovernor.state(proposalId)), 2);

        vm.prank(user1);
        bicGovernor.execute(targets, values, callDatas, keccak256(bytes("Lets mint 100 BGT for user5")));

        assertEq(bgt.balanceOf(user1), 1100);
    }
}
