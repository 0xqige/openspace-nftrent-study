pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";

import { RFTToken } from "../../../src/day4/RFTToken.sol";
import { RenftIDO } from "../../../src/day4/RFTIDO.sol";

contract RenftIDOTest is Test {
  RFTToken rftToken;

  RenftIDO renftIDO;

  address projectOwner = makeAddr("projectOwner"); // 项目方 owner
  address buyer = makeAddr("buyer"); // 买家

  uint256 price = 0.001 ether;
  uint256 softCap = 10 ether;
  uint256 hardCap = 20 ether;
  uint256 duration = 7 days;

  function setUp() public {
    vm.startPrank(projectOwner);
    rftToken = new RFTToken();
    renftIDO = new RenftIDO(address(rftToken));
    // 给 RenftIDO 转足够的 token
    rftToken.transfer(address(renftIDO), hardCap / price);
    rftToken.approve(address(renftIDO), hardCap / price);
    vm.stopPrank();

    vm.deal(buyer, 100 ether);
  }

  // 测试开启预售成功
  function test_startIDO_success() public {
    vm.startPrank(projectOwner);
    renftIDO.startIDO(price, softCap, hardCap, duration);
    vm.stopPrank();
    assertEq(true, renftIDO.isStartIDO(), "IDO should be start");
  }

  // 测试开启预售失败
  function test_startIDO_faild_when_condition_not_satisfy() public {
    vm.startPrank(projectOwner);

    vm.expectRevert();
    renftIDO.startIDO(0, softCap, hardCap, duration); // 价格为 0

    vm.expectRevert();
    renftIDO.startIDO(price, 20000, 10000, duration); // 软顶大于硬顶

    vm.expectRevert();
    renftIDO.startIDO(price, softCap, hardCap, 0); // duration 为 0

    vm.stopPrank();
  }

  // 测试预售成功
  function test_preSale_success() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    uint256 amount = 1000;
    renftIDO.preSale{ value: 1 ether }(amount);

    assertEq(1000, renftIDO.totalSoldCount(), "totalSoldCount should be 1");
    assertEq(1 ether, renftIDO.totalRaisedAmount(), "totalRaisedAmount should be 1 ether");
    assertEq(1000, renftIDO.getUserBalance(buyer), "balance should be 10");
    vm.stopPrank();
  }

  // 测试预售失败-没有开启预售
  function test_preSale_failed_when_IDO_not_start() public {
    vm.startPrank(buyer);

    uint256 amount = 1000;
    vm.expectRevert("RenftIDO: not start ido");
    renftIDO.preSale{ value: 1 ether }(amount);
    vm.stopPrank();
  }

  // 测试预售失败-当前时间不在预售期间
  function test_preSale_failed_when_not_presale_time() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    vm.warp(block.timestamp + 20 days); // 设置已经结束的时间
    uint256 amount = 1000;
    vm.expectRevert("RenftIDO: current time can not buy");
    renftIDO.preSale{ value: 1 ether }(amount);
    vm.stopPrank();
  }

  // 测试预售失败-检查用户支付的 ETH 必须等于预售数量的价格
  function test_preSale_failed_when_condition_not_satisfy() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    // 检查用户支付的 ETH 必须等于预售数量的价格
    uint256 amount = 10;
    vm.expectRevert("RenftIDO: amount is not equal to pay value");
    renftIDO.preSale{ value: 1 ether }(amount);

    // 检查当前预售后不超过募集上限
    amount = 20000;
    renftIDO.preSale{ value: 20 ether }(amount);
    vm.expectRevert("RenftIDO:exceed hardCap");
    renftIDO.preSale{ value: 20 ether }(amount);
    vm.stopPrank();
  }

  // 测试 refund 成功
  function test_refund_success() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    uint256 amount = 1000;
    renftIDO.preSale{ value: 1 ether }(amount);
    vm.stopPrank();

    vm.warp(block.timestamp + duration + 1 days); // 将时间设置到结束
    vm.startPrank(buyer);
    renftIDO.refund();
    assertEq(100 ether, buyer.balance, "buyer balance should be 100 ether");
    // assertEq(0, renftIDO.totalSoldCount, "totalSoldCount want be 0");
    // assertEq(0, renftIDO.totalRaisedAmount, "totalRaisedAmount want be 0");
    vm.stopPrank();
  }

  // 测试 refund 失败-还没有结束
  function test_refund_failed_when_IDO_not_finish() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    uint256 amount = 1000;
    renftIDO.preSale{ value: 1 ether }(amount);
    vm.stopPrank();

    vm.warp(block.timestamp + 1 days); // 将时间设置到还没有结束
    vm.startPrank(buyer);
    vm.expectRevert("RenftIDO: current time can not refund");
    renftIDO.refund();
    vm.stopPrank();
  }

  // 测试 refund 失败-还没有结束
  function test_refund_failed_when_presale_success() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    uint256 amount = 20000;
    renftIDO.preSale{ value: 20 ether }(amount);
    vm.stopPrank();

    vm.warp(block.timestamp + duration + 1 days); // 将时间设置到结束
    vm.startPrank(buyer);
    vm.expectRevert("RenftIDO: fundraising success,can not refund");
    renftIDO.refund();
    vm.stopPrank();
  }

  // 测试 refund 失败-用户没有余额
  function test_refund_failed_when_user_no_balance() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    uint256 amount = 100;
    renftIDO.preSale{ value: 0.1 ether }(amount);
    vm.stopPrank();

    vm.warp(block.timestamp + duration + 1 days); // 将时间设置到结束
    address userWithoutBalance = makeAddr("userWithoutBalance");
    vm.startPrank(userWithoutBalance);
    vm.expectRevert("RenftIDO: user balance is zero");
    renftIDO.refund();
    vm.stopPrank();
  }

  // 测试 claim 成功
  function test_claim_success() public {
    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);
    uint256 amount = 1000;
    renftIDO.preSale{ value: 1 ether }(amount);
    vm.stopPrank();

    address newBuyer = makeAddr("newBuyer");
    vm.deal(newBuyer, 10 ether);
    vm.startPrank(newBuyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    amount = 10000;
    renftIDO.preSale{ value: 10 ether }(amount);
    vm.stopPrank();

    vm.warp(block.timestamp + duration + 1 days); // 将时间设置到结束
    vm.startPrank(buyer);
    console.log("address(buyer):", address(buyer));
    renftIDO.claim();
    assertEq(1000, rftToken.balanceOf(buyer), "buyer balance should be 1000");
    vm.stopPrank();
  }

  // 测试 withdraw
  function test_withdraw_success() public {
    vm.startPrank(projectOwner);
    renftIDO.startIDO(price, softCap, hardCap, duration);
    vm.stopPrank();

    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    uint256 amount = 20000;
    renftIDO.preSale{ value: 20 ether }(amount);
    vm.stopPrank();

    vm.warp(block.timestamp + duration + 1 days); // 将时间设置到结束
    vm.startPrank(projectOwner);
    renftIDO.withdraw();
    assertEq(20 ether, projectOwner.balance, "projectOwner balance should be 20 ether");
    vm.stopPrank();
  }

   function test_withdraw_failed_when_presale_failed() public {
    vm.startPrank(projectOwner);
    renftIDO.startIDO(price, softCap, hardCap, duration);
    vm.stopPrank();

    vm.startPrank(buyer);
    renftIDO.startIDO(price, softCap, hardCap, duration);

    uint256 amount = 2000;
    renftIDO.preSale{ value: 2 ether }(amount);
    vm.stopPrank();

    vm.warp(block.timestamp + duration + 1 days); // 将时间设置到结束
    vm.startPrank(projectOwner);
    vm.expectRevert();
    renftIDO.withdraw();
    vm.stopPrank();
  }
}
/*  */