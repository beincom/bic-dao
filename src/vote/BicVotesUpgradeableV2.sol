// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../token/NftVote.sol";
import "@openzeppelin/contracts-upgradeable/governance/utils/VotesUpgradeable.sol";
import "./BicVotesUpgradeable.sol";
import "hardhat/console.sol";


contract BicVotesUpgradeableV2 is BicVotesUpgradeable {
    address public nftAddress;

    function initializeV2(
        address _nftAddress
    ) reinitializer(2) public {
        nftAddress = _nftAddress;
    }

    function _getVotingUnits(address owner) internal view virtual override returns (uint256) {
        console.log("BicVotesUpgradeableV2 _getVotingUnits");
//        return super._getVotingUnits(owner) + NftVote(nftAddress).balanceOf(owner)*1000;
        return 2000;
    }
}
