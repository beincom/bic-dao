// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IBeinGiveTake.sol";
import "../interfaces/IBeinCommunity.sol";
import "@openzeppelin/contracts/governance/utils/Votes.sol";

contract BicPower is Votes {
    address public bgtAddress;
    address public bicAddress;
    string private _name;
    string private _symbol;
    mapping(address => uint256) public currentDelegateAmount;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address _bgtAddress, address _bicAddress) EIP712("BIC Powers", "1") {
        bgtAddress = _bgtAddress;
        bicAddress = _bicAddress;
        _name = "BIC Powers";
        _symbol = "BIC POWERS";
    }

    function _getVotingUnits(address owner) internal view virtual override returns (uint256) {
        return IBeinGiveTake(bgtAddress).balanceOf(owner);
    }

    function CLOCK_MODE() public view virtual override returns (string memory) {
        return Votes.CLOCK_MODE();
    }

    function clock() public view virtual override returns (uint48) {
        return Votes.clock();
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return IBeinGiveTake(bgtAddress).totalSupply();
    }

    function balanceOf(address account) public view returns (uint256) {
        return _getVotingUnits(account);
    }

    function _delegate(address owner, address delegatee) internal virtual override {
        require(!IBeinCommunity(bicAddress).blacklist(owner), "BIC: blacklisted");
        uint256 oldDelegateAmount = currentDelegateAmount[owner];
        uint256 newDelegateAmount = _getVotingUnits(owner);

        // update in case BGT be minted
        if(newDelegateAmount > oldDelegateAmount) {
            super._transferVotingUnits(address(0), delegatee, newDelegateAmount - oldDelegateAmount);
            emit Transfer(address(0), delegatee, newDelegateAmount - oldDelegateAmount);
        }
        currentDelegateAmount[owner] = newDelegateAmount;
        super._delegate(owner, delegatee);
    }
}
