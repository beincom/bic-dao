// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../token/BeinGiveTake.sol";
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/utils/Votes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "forge-std/console.sol";

contract BgtVote is Governor, GovernorCountingSimple, GovernorSettings, Votes {
    address public bgtAddress;
    constructor(address _bgtAddress) Governor("BGT Vote") GovernorSettings(5, 50, 100) {
        bgtAddress = _bgtAddress;
    }

    function proposalThreshold()
    public
    view
    override(Governor, GovernorSettings)
    returns (uint256)
    {
        return GovernorSettings.proposalThreshold();
    }

    function CLOCK_MODE() public view virtual override(Governor, Votes) returns (string memory) {
        return Votes.CLOCK_MODE();
    }

    function clock() public view virtual override(Governor, Votes) returns (uint48) {
        return Votes.clock();
    }

    function _getVotes(address account, uint256 timepoint, bytes memory /* params */) internal view virtual override returns (uint256) {
        return Votes.getPastVotes(account, timepoint);
    }

    function _getVotingUnits(address owner) internal view virtual override returns (uint256) {
        return BeinGiveTake(bgtAddress).balanceOf(owner);
    }

    function quorum(uint256 /* timepoint */) public view virtual override returns (uint256) {
        return 0;
    }
}
