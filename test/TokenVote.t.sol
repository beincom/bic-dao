// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../src/token/TokenVote.sol";
import "forge-std/Test.sol";

contract TokenVoteTest is Test {
    TokenVote public tokenVote;
    uint256 public user1PKey = 0x1;
    address public user1 = vm.addr(user1PKey);
    uint256 public user2PKey = 0x2;
    address public user2 = vm.addr(user2PKey);

    function setUp() public {
        tokenVote = new TokenVote();
    }

    function testTokenVote() public {
        assertEq(tokenVote.name(), "BIC Vote");
        assertEq(tokenVote.symbol(), "BICV");
        assertEq(tokenVote.decimals(), 18);
        assertEq(tokenVote.totalSupply(), 0);
    }

    function testDelegate() public {
        tokenVote.mintTo(user1, 100);
        assertEq(tokenVote.balanceOf(user1), 100);
        assertEq(tokenVote.getVotes(user1), 0);

        vm.prank(user1);
        tokenVote.delegate(user1);
        assertEq(tokenVote.getVotes(user1), 100);
        assertEq(tokenVote.getVotes(user2), 0);

        tokenVote.mintTo(user1, 100);
        assertEq(tokenVote.getVotes(user1), 200);

        vm.prank(user1);
        tokenVote.transfer(user2, 100);
        assertEq(tokenVote.getVotes(user1), 100);
        assertEq(tokenVote.getVotes(user2), 0);

        vm.prank(user2);
        tokenVote.delegate(user2);
        assertEq(tokenVote.getVotes(user1), 100);
        assertEq(tokenVote.getVotes(user2), 100);

        vm.prank(user1);
        tokenVote.delegate(user2);
        assertEq(tokenVote.getVotes(user1), 0);
        assertEq(tokenVote.getVotes(user2), 200);

        tokenVote.mintTo(user1, 100);
        assertEq(tokenVote.getVotes(user1), 0);
        assertEq(tokenVote.getVotes(user2), 300);
    }
}
