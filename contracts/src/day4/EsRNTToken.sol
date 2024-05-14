// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract EsRNTToken is ERC20Permit {
  // 持有 rftToken(锁仓)
  constructor() ERC20Permit("EsRNTToken") ERC20("EsRNTToken", "EsRNT") { }

  function mint(address account, uint256 value) external {
    _mint(account, value);
  }

  // burn locked esToken
  function burn(address account, uint256 value) external {
    _burn(account, value);
  }
}
