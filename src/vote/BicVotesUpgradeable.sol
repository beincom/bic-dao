// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../token/BeinGiveTake.sol";
import "@openzeppelin/contracts-upgradeable/governance/utils/VotesUpgradeable.sol";

contract BicVotesUpgradeable is VotesUpgradeable {
    address public bgtAddress;
    string private _name;
    string private _symbol;

    function initialize(
        address _bgtAddress
    ) public initializer {
        bgtAddress = _bgtAddress;
        _name = "Bic Votes";
        _symbol = "BICVs";
    }

    function _getVotingUnits(address owner) internal view virtual override returns (uint256) {
        return BeinGiveTake(bgtAddress).balanceOf(owner);
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
