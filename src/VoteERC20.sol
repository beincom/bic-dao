import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";

contract VoteERC20 is GovernorVotes {
    constructor(ERC20Votes _token) GovernorVotes(_token) {}

    function votingDelay() public pure override returns (uint256) {
        return 0;
    }

    function votingPeriod() public pure override returns (uint256) {
        return 100;
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0;
    }

    function quorum(uint256) public pure override returns (uint256) {
        return 0;
    }

    function _quorumReached(uint256) internal pure override returns (bool) {
        return true;
    }

    function _execute(uint256 proposalId) internal override {
        emit ProposalExecuted(proposalId);
    }
}
