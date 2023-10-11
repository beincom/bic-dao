// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";

contract NftVote is ERC721Votes {
    constructor() ERC721("BIC Vote", "BICV") EIP712("Bic Votes", "1") {}

    function mintTo(address account, uint256 tokenId) public {
        _mint(account, tokenId);
    }
}
