// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./RFTToken.sol";

// 编写 IDO 合约，实现 Token 预售，需要实现如下功能：
// - 开启预售: 支持对给定的任意ERC20开启预售，设定预售价格，募集ETH目标，超募上限，预售时长。
// - 任意用户可支付ETH参与预售；
// - 预售结束后，如果没有达到募集目标，则用户可领会退款；
// - 预售成功，用户可领取 Token，且项目方可提现募集的ETH；
contract RenftIDO {
  // // 事件：预售开始
  // event Started(uint256 start, uint256 end);
  // // 事件：预售结束
  // event Ended(uint256 raised, uint256 sold);
  // // 事件：用户支付ETH
  // event Paid(address indexed user, uint256 amount);
  // // 事件：用户领取Token
  // event Claimed(address indexed user, uint256 amount);
  // // 事件：用户领取ETH
  // event Refunded(address indexed user, uint256 amount);

  modifier onlyOwner() {
    require(msg.sender == owner, "RenftIDO: only owner can call");
    _;
  }

  // 必须开始预售
  modifier mustStartIDO() {
    require(isStartIDO, "RenftIDO: not start ido");
    _;
  }

  // 预售开始事件
  event RenftIDO_Start(address indexed owner, address indexed token);

  // ERC20
  IERC20 public erc20Token;

  // 发售的项目方
  address public owner;

  // 预售单个token价格
  uint256 public price;

  // 募集目标金额（软顶）
  uint256 public softCap;

  // 募集上限金额（硬顶）
  uint256 public hardCap;

  // 预售时长
  uint256 public end_time;

  // 总的销售数量
  uint256 public totalSoldCount;

  // 总的募集金额
  uint256 public totalRaisedAmount;

  // 用户余额
  mapping(address => uint256) balances;

  // 用户是否已经领取
  mapping(address => bool) userClaimed;

  // 是否已经开始预售
  bool public isStartIDO;

  // 记录用户数
  uint256 public userSize;

  constructor(address _token) {
    erc20Token = IERC20(_token);
    owner = msg.sender;
  }

  // 开启预售
  function startIDO(uint256 _price, uint256 _softCap, uint256 _hardCap, uint256 _duration) external {
    // 1.参数校验
    // - 价格大于 0
    require(_price > 0, "price must be greater than 0");
    // - 软顶小于硬顶
    require(_softCap < _hardCap, "softCap must be less than hardCap");
    // - 当前合约的有足够的 token 大于等于 _softCap/_price （_token 需要将足够的 token 转移到当前合约）
    require(erc20Token.balanceOf(address(this)) >= _softCap / _price, "not enough token");
    // - 时间大于0
    require(_duration > 0, "duration must be greater than 0");

    // 2.参数初始化
    price = _price;
    softCap = _softCap;
    hardCap = _hardCap;
    end_time = block.timestamp + _duration;
    isStartIDO = true;

    // 触发预售开始事件
    emit RenftIDO_Start(msg.sender, address(erc20Token));
  }

  // 预售
  function preSale(uint256 amount) external payable mustStartIDO {
    // 检查当前时间在预售期间
    require(block.timestamp < end_time, "RenftIDO: current time can not buy");

    // 检查用户支付的 ETH 必须等于预售数量的价格
    require(msg.value == amount * price, "RenftIDO: amount is not equal to pay value");

    // 检查预售后不超过 NFT Token 发行量，防止超售
    require(totalSoldCount + amount <= erc20Token.totalSupply(), "RenftIDO:exceed totalSupply");

    // 检查当前预售后不超过募集上限
    require(totalRaisedAmount + amount <= hardCap, "RenftIDO:exceed hardCap");

    // 更新已募集的数量
    totalSoldCount += amount;

    // 更新募集的金额
    totalRaisedAmount += msg.value;

    // 更新用户的余额
    balances[msg.sender] += amount;

    //如果用户不存在，则用户数+1
    if (balances[msg.sender] == 0) {
      userSize++;
    }
  }

  // 预售结束后，如果没有达到募集目标，则用户可领回退款
  function refund() external mustStartIDO {
    // 检查当前时间在预售后
    require(block.timestamp >= end_time, "RenftIDO: current time can not refund");

    // 检查预售失败
    require(totalRaisedAmount < softCap, "RenftIDO: fundraising success,can not refund");

    // 检查用户余额大于 0
    address user = msg.sender;
    require(balances[user] > 0, "RenftIDO: user balance is zero");

    // 给用户退款
    uint256 amount = balances[user];
    balances[user] = 0;
    payable(msg.sender).transfer(amount * price);

    // 总的销售数量减少
    totalSoldCount -= amount;

    // 总募资金额减少
    totalRaisedAmount -= amount * price;
  }

  // 预售成功，用户可领取 Token
  function claim() external mustStartIDO {
    // 检查当前时间在预售结束后
    require(block.timestamp >= end_time, "RenftIDO: current time can not claim");

    address sender = msg.sender;
    // 检查用户已经领取过
    require(!userClaimed[sender], "RenftIDO: user already claimed");

    // 检查预售成功
    require(totalRaisedAmount >= softCap, "RenftIDO: fundraising fail");

    // 检查用户余额大于 0
    require(balances[sender] > 0, "RenftIDO: user balance is zero");

    // 给用户转 RFTToken
    uint256 amount = balances[sender];
    erc20Token.transfer(sender, amount);

    // 达到硬顶，将多余的部分退回给用户,平均分超出部分
    if (totalRaisedAmount > hardCap) {
      uint256 refundAmount = (totalRaisedAmount - hardCap) / userSize;
      payable(sender).transfer(refundAmount);
    }

    // 更新用户已领取状态
    userClaimed[sender] = true;
  }

  // 项目方提现募集的ETH
  function withdraw() external onlyOwner mustStartIDO {
    // 检查募资已经结束
    require(block.timestamp >= end_time, "RenftIDO: current time can not withdraw");

    // 检查募资成功
    require(totalRaisedAmount >= softCap, "RenftIDO: fundraising fail");

    // 项目方提现
    payable(owner).transfer(address(this).balance);
  }

  function getUserBalance(address user) external returns (uint256) {
    return balances[user];
  }
}
