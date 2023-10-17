// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../token/BeinGiveTake.sol";
import "../token/NftVote.sol";
import "@openzeppelin/contracts-upgradeable/governance/utils/VotesUpgradeable.sol";
import "hardhat/console.sol";

contract BicVotesUpgradeableV12 is VotesUpgradeable {
    address public bgtAddress;
    string private _name;
    string private _symbol;
    address public nftAddress;

    function initialize(
        address _bgtAddress,
        address _nftAddress
    ) public reinitializer(2) {
        bgtAddress = _bgtAddress;
        _name = "Bic Votes";
        _symbol = "BICVs";
        nftAddress = _nftAddress;
    }

    function _getVotingUnits(address owner) internal view virtual override returns (uint256) {
        console.log("BicVotesUpgradeableV12 _getVotingUnits");
        return BeinGiveTake(bgtAddress).balanceOf(owner) + NftVote(nftAddress).balanceOf(owner)*1000;
    }

    function CLOCK_MODE() public view virtual override returns (string memory) {
        return VotesUpgradeable.CLOCK_MODE();
    }

    function clock() public view virtual override returns (uint48) {
        return VotesUpgradeable.clock();
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return BeinGiveTake(bgtAddress).totalSupply();
    }

    function balanceOf(address account) public view returns (uint256) {
        return _getVotingUnits(account);
    }
}
