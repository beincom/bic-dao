// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract TokenVote is ERC20Votes, ERC20Permit {
    constructor() ERC20("Votes", "VOTE") ERC20Permit("Votes") {}

    function mintTo(address account, uint256 amount) public {
        _mint(account, amount);
    }

    function _update(address from, uint256 to, uint256 value) internal virtual override(ERC20, ERC20Votes) {
        return ERC20Votes._update(from, to, value);
    }
}
