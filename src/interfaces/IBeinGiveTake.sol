// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IBeinGiveTake {
    function DEFAULT_ADMIN_ROLE() external pure returns (bytes32);
    function MINT_ROLE() external pure returns (bytes32);
    function mintTo(address account, uint256 amount) external;
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}
