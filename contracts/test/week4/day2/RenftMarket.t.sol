pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { RenftMarket } from "../../../src/RenftMarket.sol";
import { S2NFT } from "../../../src/NFTFactory.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract RenftMarketTest is Test {
  RenftMarket renftMarket;
  S2NFT nft;

  address maker;
  address taker = makeAddr("taker");
  uint256 makerPrivateKey = 11111;

  function setUp() public {
    maker = vm.addr(makerPrivateKey);

    renftMarket = new RenftMarket();
    vm.startPrank(maker);
    nft = new S2NFT("name", "symbol", "baseURI", 1000);
    nft.freeMint(3);
    vm.stopPrank();
    vm.deal(maker, 10 ether);
    vm.deal(taker, 10 ether);
  }

  // test borrow
  function test_borrow_suucess() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp + 30 days
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.给市场授权
    vm.startPrank(maker);
    nft.approve(address(renftMarket), 1);
    vm.stopPrank();

    // 3.调用 borrow
    vm.startPrank(taker);
    renftMarket.borrow{ value: 1 ether }(order, makerSignature);
    vm.stopPrank();

    // 4.断言
    (address gotTaker, uint256 collateral, uint256 start_time, RenftMarket.RentoutOrder memory rentinfo) =
      renftMarket.orders(renftMarket.orderHash(order));
    assertEq(taker, gotTaker);
  }

  // test borrow faild when current time is greater than list_endtime
  function test_borrow_faild_when_list_endtime() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp - 1
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.给市场授权
    vm.startPrank(maker);
    nft.approve(address(renftMarket), 1);
    vm.stopPrank();

    // 3.调用 borrow
    vm.startPrank(taker);
    vm.expectRevert("RenftMarket: ORDER_EXPIRED");
    renftMarket.borrow{ value: 1 ether }(order, makerSignature);
    vm.stopPrank();
  }

  // test borrow faild when INSUFFICIENT_AMOUNT
  function test_borrow_faild_when_INSUFFICIENT_AMOUNT() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp + 30 days
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.给市场授权
    vm.startPrank(maker);
    nft.approve(address(renftMarket), 1);
    vm.stopPrank();

    // 3.调用 borrow
    vm.startPrank(taker);
    vm.expectRevert("RenftMarket: INSUFFICIENT_AMOUNT");
    renftMarket.borrow{ value: 1000 }(order, makerSignature);
    vm.stopPrank();
  }

  // test borrow faild when NFT_RENTED
  function test_borrow_faild_when_NFT_RENTED() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp + 30 days
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.给市场授权
    vm.startPrank(maker);
    nft.approve(address(renftMarket), 1);
    vm.stopPrank();

    // 3.调用 borrow
    vm.startPrank(taker);
    renftMarket.borrow{ value: 1 ether }(order, makerSignature);
    vm.stopPrank();

    address anotherTaker = makeAddr("anotherTaker");
    vm.deal(anotherTaker, 10 ether);
    // 4.调用 borrow
    vm.startPrank(anotherTaker);
    vm.expectRevert("RenftMarket: NFT_RENTED");
    renftMarket.borrow{ value: 1 ether }(order, makerSignature);
    vm.stopPrank();
  }

  // test borrow faild when CANNOT_RENT_SELF
  function test_borrow_faild_when_CANNOT_RENT_SELF() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp + 30 days
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.给市场授权
    vm.startPrank(maker);
    nft.approve(address(renftMarket), 1);
    vm.stopPrank();

    // 3.调用 borrow
    vm.startPrank(maker);
    vm.expectRevert("RenftMarket: CANNOT_RENT_SELF");
    renftMarket.borrow{ value: 1 ether }(order, makerSignature);
    vm.stopPrank();
  }

  // test borrow faild when ORDER_CANCELED
  function test_borrow_faild_when_ORDER_CANCELED() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp + 10 days
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.给市场授权
    vm.startPrank(maker);
    nft.approve(address(renftMarket), 1);
    vm.stopPrank();

    // 3.调用 cancelOrder
    vm.startPrank(maker);
    renftMarket.cancelOrder(order, makerSignature);
    vm.stopPrank();

    // 4.调用 borrow
    vm.startPrank(taker);
    vm.expectRevert("RenftMarket: ORDER_CANCELED");
    renftMarket.borrow{ value: 1 ether }(order, makerSignature);
    vm.stopPrank();
  }


  // test cancelOrder
  function test_cancelOrder_success() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp + 30 days
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.调用 cancelOrder
    vm.startPrank(maker);
    renftMarket.cancelOrder(order, makerSignature);
    vm.stopPrank();

    // 3.断言
    bool isCancled = renftMarket.canceledOrders(renftMarket.orderHash(order));
    assertTrue(isCancled);
  }

  // test cancelOrder failed case
  function test_cancelOrder_failed() public {
    // 1. 准备参数
    RenftMarket.RentoutOrder memory order = RenftMarket.RentoutOrder({
      maker: maker,
      nft_ca: address(nft),
      token_id: 1,
      daily_rent: 2,
      max_rental_duration: 365,
      min_collateral: 10000,
      list_endtime: block.timestamp + 30 days
    });
    bytes32 digest = MessageHashUtils.toTypedDataHash(renftMarket.domainSeparator(), renftMarket.orderHash(order));
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(makerPrivateKey, digest);
    bytes memory makerSignature = abi.encodePacked(r, s, v);

    // 2.调用 cancelOrder
    vm.startPrank(maker);
    renftMarket.cancelOrder(order, makerSignature);
    vm.stopPrank();

    // 3.断言
    bool isCancled = renftMarket.canceledOrders(renftMarket.orderHash(order));
    assertTrue(isCancled);

    // 4.再次调用 cancelOrder
    vm.startPrank(maker);
    vm.expectRevert();
    renftMarket.cancelOrder(order, makerSignature);
    vm.stopPrank();
  }
}
