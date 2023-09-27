// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/governance/Governor.sol";
import "../token/BeinGiveTake.sol";

contract BgtVote is Governor {
    constructor() Governor("BGT Vote") {}

    function clock() public view virtual override returns (uint48) {
        return SafeCast.toUint48(block.number);
    }

    function CLOCK_MODE() public view virtual override returns (string memory) {
        return "mode=blocknumber&from=default";
    }

    function COUNTING_MODE() public pure virtual override returns (string memory) {
        return "quadratic";
    }

    function _countVote(
        uint256 proposalId,
        address account,
        uint8 support,
        uint256 weight,
        bytes memory params
    ) internal virtual override {
        BeinGiveTake bgt = BeinGiveTake(0x5FbDB2315678afecb367f032d93F642f64180aa3);
//        bgt.mintTo(account, votes);
    }

    function _getVotes(
        address account,
        uint256 timepoint,
        bytes memory /*params*/
    ) internal view virtual override returns (uint256) {
        BeinGiveTake bgt = BeinGiveTake(0x5FbDB2315678afecb367f032d93F642f64180aa3);
        return 1234;
    }

    function _quorumReached(uint256 proposalId) internal view virtual override returns (bool) {
        return true;
    }

    function quorum(uint256 timepoint) public view virtual override returns (uint256) {
        return timepoint / 2 + 1;
    }

    function _voteSucceeded(uint256 proposalId) internal view virtual override returns (bool) {
        return true;
    }

    function hasVoted(uint256 proposalId, address account) public view virtual override returns (bool) {
        return true;
    }

    function votingDelay() public pure virtual override returns (uint256) {
        return 0;
    }

    function votingPeriod() public pure virtual override returns (uint256) {
        return 100;
    }

}
