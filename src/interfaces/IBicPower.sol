// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/interfaces/IERC5805.sol";

interface IBicPower is IERC5805 {
    function bicAddress() external view returns (address);
}
