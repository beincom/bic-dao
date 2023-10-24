// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../src/test/BeinGiveTake.sol";
import "../src/test/BeinChain.sol";
import "../src/governance/BicGovernor.sol";
import "../src/vote/BicPower.sol";
import "forge-std/Test.sol";

contract BicPowerTest is Test {
    BeinGiveTake public bgt;
    BeinChain public bic;
    BicPower public bicPower;

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
        bic = new BeinChain();
        bicPower = new BicPower(address(bgt), address(bic));

        bgt.mintTo(user1, 1000);
        bgt.mintTo(user2, 2000);
        bgt.mintTo(user3, 3000);
        bgt.mintTo(user4, 4000);

        bgt.grantRole(bgt.MINT_ROLE(), address(bicPower));
    }

    function testPower() public {
        vm.prank(user1);
        bicPower.delegate(user1);
        vm.roll(block.number + 1);
        assertEq(bicPower.getVotes(user1), 1000);
        vm.roll(block.number + 1);
        assertEq(bicPower.getPastTotalSupply(block.number - 1), 1000);

        bgt.mintTo(user1, 1500);
        vm.roll(block.number + 1);
        assertEq(bicPower.getVotes(user1), 1000);

        vm.prank(user1);
        bicPower.delegate(user1);
        vm.roll(block.number + 1);
        console.log("balanceOf %s", bicPower.balanceOf(user1));
        console.log("getVotes %s", bicPower.getVotes(user1));
        assertEq(bicPower.getVotes(user1), 2500);
        assertEq(bicPower.getPastTotalSupply(block.number - 1), 2500);

    }
}
