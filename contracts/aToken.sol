// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract aToken is ERC20 {
    constructor() ERC20("aToken", "aTK") {
        _mint(msg.sender, 90000000 * 10 ** decimals());
    }
}





