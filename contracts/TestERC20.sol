// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ERC20Permit.sol";

/**
    @dev Sample ERC20 contract to demonstrate any old contract is compatible with erc20 permit contract after it inherits erc20 permit contract. Only constructor needs to be modified. No change in any function required.
*/
contract TestERC20 is ERC20Permit {
    constructor () ERC20Permit("ERC20 Permit", "ERCP") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
