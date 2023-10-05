// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract BicGovernor is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes {
    constructor(address _bicVote) Governor("BIC Vote") GovernorSettings(60, 300, 100) GovernorVotes(IVotes(_bicVote)) {} //delay 3' vote 15' threshold 100 wei BGT

    function proposalThreshold()
    public
    view
    override(Governor, GovernorSettings)
    returns (uint256)
    {
        return GovernorSettings.proposalThreshold();
    }

    function quorum(uint256 /* timepoint */) public view virtual override returns (uint256) {
        return 0;
    }
}
