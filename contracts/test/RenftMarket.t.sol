// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console } from "forge-std/Test.sol";
import { RenftMarket } from "../src/RenftMarket.sol";
import { S2NFT } from "../src/NFTFactory.sol";
import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract CounterTest is Test {
  RenftMarket public mkt;
  S2NFT public nft;
  address opensky;
  address opensky1;
  uint256 privateKey;
  uint256 privateKey1;
  //keccak256("RentoutOrder(address maker,address nft_ca,uint256 token_id,uint256 daily_rent,uint256 max_rental_duration, uint256 min_collateral,uint256 list_endtime)");
  bytes32 public constant ORDER_HASH = 0x7aacd3704d4b2c8394cd9d9b45bd3ea360eadb5bc98475d01d4273578b01f9a2;

  function setUp() public {
    mkt = new RenftMarket();
    nft = new S2NFT("OpenSky", "OS", "http://baidu.com", 8888);
    (opensky, privateKey) = makeAddrAndKey("address");
    (opensky1, privateKey1) = makeAddrAndKey("address");
    vm.startPrank(opensky);
    nft.freeMint(5);
    vm.stopPrank();
    deal(opensky, 100 ether);
    deal(opensky1, 100 ether);
  }

  function test_borrow() public {
    //出租方挂单授权
    vm.startPrank(opensky);
    RenftMarket.RentoutOrder memory order =
      RenftMarket.RentoutOrder(opensky, address(nft), 0, 100 gwei, 100 days, 0.01 ether, 100 days);
    nft.approve(address(mkt), order.token_id);
    vm.stopPrank();

    //租户租赁
    vm.startPrank(opensky1);
    bytes32 structHash = keccak256(
      abi.encode(
        ORDER_HASH,
        order.maker,
        order.nft_ca,
        order.token_id,
        order.daily_rent,
        order.max_rental_duration,
        order.min_collateral,
        order.list_endtime
      )
    );

    bytes32 digest = MessageHashUtils.toTypedDataHash(mkt.domainSeparatorV4(), structHash);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey1, digest);
    mkt.borrow{ value: order.min_collateral }(order, abi.encodePacked(r, s, v));

    vm.stopPrank();
  }

  function test_cancelOrder() public {
    //出租方挂单授权
    vm.startPrank(opensky);
    RenftMarket.RentoutOrder memory order =
      RenftMarket.RentoutOrder(opensky, address(nft), 0, 100 gwei, 100 days, 0.01 ether, 100 days);
    nft.approve(address(mkt), order.token_id);
    vm.stopPrank();

    //租户租赁
    vm.startPrank(opensky1);
    bytes32 structHash = keccak256(
      abi.encode(
        ORDER_HASH,
        order.maker,
        order.nft_ca,
        order.token_id,
        order.daily_rent,
        order.max_rental_duration,
        order.min_collateral,
        order.list_endtime
      )
    );

    bytes32 digest = MessageHashUtils.toTypedDataHash(mkt.domainSeparatorV4(), structHash);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey1, digest);
    mkt.borrow{ value: order.min_collateral }(order, abi.encodePacked(r, s, v));

    vm.stopPrank();

    //出租方取消订单
    vm.startPrank(opensky);
    bytes32 structHash1 = keccak256(
      abi.encode(
        ORDER_HASH,
        order.maker,
        order.nft_ca,
        order.token_id,
        order.daily_rent,
        order.max_rental_duration,
        order.min_collateral,
        order.list_endtime
      )
    );

    bytes32 digest1 = MessageHashUtils.toTypedDataHash(mkt.domainSeparatorV4(), structHash1);

    (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(privateKey, digest1);
    mkt.cancelOrder(order, abi.encodePacked(r1, s1, v1));
    vm.stopPrank();
  }
}
