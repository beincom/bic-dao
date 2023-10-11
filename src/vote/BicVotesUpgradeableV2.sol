// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../token/NftVote.sol";
import "@openzeppelin/contracts-upgradeable/governance/utils/VotesUpgradeable.sol";
import "./BicVotesUpgradeable.sol";


contract BicVotesUpgradeableV2 is BicVotesUpgradeable {
    address public nftAddress;

    function initializeV2(
        address _nftAddress
    ) reinitializer(2) public {
        nftAddress = _nftAddress;
    }
}
