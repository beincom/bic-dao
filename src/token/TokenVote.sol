// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";


contract TokenVote is ERC20Votes {
    constructor() ERC20("Votes", "VOTE") EIP712("Token votes", "1") {}

    function mintTo(address account, uint256 amount) public {
        _mint(account, amount);
    }

}
