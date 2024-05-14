// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.25;

// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "./RFTToken.sol";

// // 需求
// // 编写一个质押挖矿合约，实现如下功能：
// // - 用户随时可以质押项目方代币 RNT(自定义的ERC20) ，开始赚取项目方Token(esRNT)；
// // - 可随时解押提取已质押的 RNT；
// // - 可随时领取esRNT奖励，每质押1个RNT每天可奖励 1 esRNT;
// // - esRNT 是锁仓性的 RNT， 1 esRNT 在 30 天后可兑换 1 RNT，随时间线性释放，支持提前将 esRNT 兑换成 RNT，但锁定部分将被 burn 燃烧掉。
// contract RFTStake {
//   // 项目方 token
//   IERC20 public rftToken;

//   ERC20 public esRNT;

//   // 用户质押的余额: key:user, value:质押的 RNT 数量
//   mapping(address => uint256) _balances;

//   // 用户质押信息
//   mapping(address => Stake) _stakes;

//   constructor(address _rftToken, address _esRNT) {
//     rftToken = IERC20(_rftToken);
//     esRNT = ERC20(_esRNT);
//   }

//   struct Stake {
//     uint256 rewards; // esToken 奖励
//     uint256 lastUpdateTime; // 上一次的更新时间：用于计算从上次到本次的时间差
//   }

//   // 计算用户的奖励
//   modifier before() {
//     Stake stake = _stakes[msg.sender];
//     // 获取用户上次的质押时间
//     uint256 userStakeTime = stake.lastUpdateTime;

//     // 计算上次质押时间到此时的天数
//     uint256 rewardDays = (block.timestamp - userStakeTime) / 1 days;

//     // 计算奖励:每质押1个RNT每天可奖励 1 esRNT
//     uint256 rewardEsNFTAmount = rewardDays * 1 * _balances[msg.sender];

//     // 更新奖励
//     stake.rewards += rewardEsNFTAmount;
//     _;
//   }

//   // 质押
//   function stake(uint256 amount) external before {
//     // 转账：质押需要用户 approve
//     rftToken.transferFrom(msg.sender, address(this), amount);

//     // 更新用户的质押余额
//     _balances[msg.sender] += amount;

//     // 记录用户的质押信息
//     if (!_stakes[msg.sender]) {
//       _stakes[msg.sender] = Stake({ rewards: 0, lastUpdateTime: block.timestamp });
//     }
//   }

//   // 解押
//   function unstake() external {
//     // 检查用户质押的余额不为 0
//     require(balances[msg.sender] >= 0, "RFTStake-unstake:insufficient balance");

//     // 当前合约给用户转账
//     rftToken.transferFrom(address(this), msg.sender, balances[msg.sender]);

//     // 更新用户的 esTokenInfo
//     EsTokenInfo[] memory esTokenInfos = _esTokenInfos[msg.sender];
//     // 将质押的额度清空，并计算保存解押后的奖励
//     for (uint256 i = 0; i < esTokenInfos.length; i++) {
//       // 计算奖励的天数
//       uint256 rewardsDays = (block.timestamp - esTokenInfos[i].stakeTime) / 1 days;

//       // 计算奖励:每质押1个RNT每天可奖励 1 esRNT
//       uint256 rewardEsNFTAmount = rewardsDays * 1 * balances[msg.sender];

//       esTokenInfos[i].stakeAmount = 0;
//       esTokenInfos[i].unstakeReward = rewardEsNFTAmount;
//     }

//     // 更新用户质押余额
//     balances[msg.sender] = 0;
//   }

//   // 用户领取奖励
//   function claim() external {
//     // 先计算用户的奖励
//     EsTokenInfo[] memory esTokenInfos = _esTokenInfos[msg.sender];
//     // - 遍历用户的 EsTokenInfo，计算用户奖励，给用户 mint esRNT
//     uint256 totalRewards = 0;
//     for (uint256 i = 0; i < esTokenInfos.length; i++) {
//       // 计算奖励的天数
//       uint256 rewardsDays = (block.timestamp - esTokenInfos[i].stakeTime) / 1 days;

//       // 计算奖励:每质押1个RNT每天可奖励 1 esRNT
//       uint256 rewardEsNFTAmount = rewardsDays * 1 * balances[msg.sender];

//       totalRewards += esTokenInfos[i].unstakeReward;
//     }

//     esRNT.mint(msg.sender, totalRewards);

//     // 计算用户的奖励可以兑换的 RNT 数量
//     rftToken.transferFrom(from, to, value);

//     // burn 掉锁仓的 esRNT

//     // 给用户转 RNT
//   }
// }
