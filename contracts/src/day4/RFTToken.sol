// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract RFTToken is ERC20Permit {
  constructor() ERC20Permit("RenftToken") ERC20("RenftToken", "RNT") {
    // totol 2100 million
    _mint(msg.sender, 21_000_000 * 1e18);
  }
}
