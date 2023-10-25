// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/utils/IVotes.sol";
import "../interfaces/IBeinCommunity.sol";
import "../interfaces/IBicPower.sol";

contract BicGovernor is Governor, GovernorSettings, GovernorCountingSimple, GovernorVotes {
//    address public bicVotes;
    constructor(address _bicVotes, uint256 initialVotingDelay, uint256 initialVotingPeriod, uint256 initialProposalThreshold)
    Governor("BIC Vote") GovernorSettings(initialVotingDelay, initialVotingPeriod, initialProposalThreshold) GovernorVotes(IBicPower(_bicVotes)) {}

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

    function _castVote(
        uint256 proposalId,
        address account,
        uint8 support,
        string memory reason
    ) internal virtual override returns (uint256) {
        require(!IBeinCommunity(IBicPower(address(token)).bicAddress()).blacklist(account), "BIC: blacklisted");
        return super._castVote(proposalId, account, support, reason);
    }
}
