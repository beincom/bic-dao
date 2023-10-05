// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract TokenVote is ERC20Votes {
    constructor() ERC20("BIC Vote", "BICV") ERC20Permit("Vote permit") {}

    function mintTo(address account, uint256 amount) public {
        _mint(account, amount);
    }
}
