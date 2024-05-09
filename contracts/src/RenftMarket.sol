// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title RenftMarket
 * @dev NFT租赁市场合约
 *   TODO:
 *      1. 退还NFT：租户在租赁期内，可以随时退还NFT，根据租赁时长计算租金，剩余租金将会退还给出租人
 *      2. 过期订单处理：
 *      3. 领取租金：出租人可以随时领取租金
 */
contract RenftMarket is EIP712 {
  // 出租订单事件
  event BorrowNFT(address indexed taker, address indexed maker, bytes32 orderHash, uint256 collateral);
  // 取消订单事件
  event OrderCanceled(address indexed maker, bytes32 orderHash);

  mapping(bytes32 => BorrowOrder) public orders; // 已租赁订单
  mapping(bytes32 => bool) public canceledOrders; // 已取消的挂单

  constructor() EIP712("RenftMarket", "V1") { }

  bytes32 public constant ORDER_HASH = 0x7aacd3704d4b2c8394cd9d9b45bd3ea360eadb5bc98475d01d4273578b01f9a2;
  // bytes32 public constant ORDER_HASH = keccak256("RentoutOrder(address maker,address nft_ca,uint256 token_id,uint256 daily_rent,uint256 max_rental_duration, uint256 min_collateral,uint256 list_endtime)");

  /**
   * @notice 租赁NFT
   * @dev 验证签名后，将NFT从出租人转移到租户，并存储订单信息
   */
  function borrow(RentoutOrder calldata order, bytes calldata makerSignature) external payable {
    require(msg.value >= order.min_collateral, "Insufficient collateral");
    
    bytes32 structHash = _cheackOrder(order, makerSignature);
    // 3. 转移NFT
    IERC721(order.nft_ca).transferFrom(order.maker, msg.sender, order.token_id);

    // 已租赁订单
    orders[structHash] = BorrowOrder(order.maker, order.min_collateral, block.timestamp, order);

    // 出租订单事件
    emit BorrowNFT(msg.sender, order.maker, structHash, msg.value);
  }

  /**
   * 1. 取消时一定要将取消的信息在链上标记，防止订单被使用！
   * 2. 防DOS： 取消订单有成本，这样防止随意的挂单，
   */
  function cancelOrder(RentoutOrder calldata order, bytes calldata signatre) external {
    bytes32 structHash = _cheackOrder(order, signatre);
    // 1. 标记取消订单
    canceledOrders[structHash] = true;
    emit OrderCanceled(order.maker, structHash);
  }

  function _cheackOrder(RentoutOrder calldata order, bytes calldata signatre) internal returns (bytes32 structHash) {
    // 1. 验证订单是否有效
    require(order.list_endtime > block.timestamp, "Order expired");
  
    // 2. 验证order签名
    structHash = orderHash(order);

    bytes32 digest = _hashTypedDataV4(structHash);
    address signer = ECDSA.recover(digest, signatre);
    require(signer == msg.sender, "sign fial");
  }

  // 计算订单哈希
  function orderHash(RentoutOrder calldata order) public view returns (bytes32) {
    return keccak256(
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
  }

  struct RentoutOrder {
    address maker; // 出租方地址
    address nft_ca; // NFT合约地址
    uint256 token_id; // NFT tokenId
    uint256 daily_rent; // 每日租金
    uint256 max_rental_duration; // 最大租赁时长
    uint256 min_collateral; // 最小抵押
    uint256 list_endtime; // 挂单结束时间
  }

  // 租赁信息
  struct BorrowOrder {
    address taker; // 租方人地址
    uint256 collateral; // 抵押
    uint256 start_time; // 租赁开始时间，方便计算利息
    RentoutOrder rentinfo; // 租赁订单
  }

  function domainSeparatorV4() public returns (bytes32) {
    return _domainSeparatorV4();
  }
}
