// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../token/BeinGiveTake.sol";
import "@openzeppelin/contracts/governance/utils/Votes.sol";

contract BicVotes is Votes {
    address public bgtAddress;
    string private _name;
    string private _symbol;
    constructor(address _bgtAddress) EIP712("Bic Votes", "1") {
        bgtAddress = _bgtAddress;
        _name = "Bic Votes";
        _symbol = "BICVs";
    }

    function _getVotingUnits(address owner) internal view virtual override returns (uint256) {
        return BeinGiveTake(bgtAddress).balanceOf(owner);
    }

    function CLOCK_MODE() public view virtual override returns (string memory) {
        return Votes.CLOCK_MODE();
    }

    function clock() public view virtual override returns (uint48) {
        return Votes.clock();
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
