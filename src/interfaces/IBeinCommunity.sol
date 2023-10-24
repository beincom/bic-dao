// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBeinCommunity is IERC20 {
    function blacklist(address account) external view returns (bool);
}
