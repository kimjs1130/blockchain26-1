// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract SimpleStaking {
    uint256 public constant LOCK_DURATION = 60;
    uint256 public constant REWARD_RATE_PER_SECOND = 1e15;

    IERC20 public immutable stakingToken;
    address public owner;
    uint256 public rewardPool;
    mapping(address => uint256) private stakedBalances;
    mapping(address => uint256) private stakeTimestamps;
    mapping(address => uint256) private rewardSnapshots;
    uint256 public totalStaked;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event EmergencyWithdrawn(address indexed user, uint256 amount);
    event RewardFunded(uint256 amount);

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "invalid token");
        stakingToken = IERC20(tokenAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "amount must be greater than 0");
        require(
            stakingToken.allowance(msg.sender, address(this)) >= amount,
            "approve token first"
        );

        rewardSnapshots[msg.sender] = pendingReward(msg.sender);
        bool success = stakingToken.transferFrom(msg.sender, address(this), amount);
        require(success, "stake transfer failed");

        stakedBalances[msg.sender] += amount;
        totalStaked += amount;
        stakeTimestamps[msg.sender] = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "amount must be greater than 0");
        require(stakedBalances[msg.sender] >= amount, "insufficient staked balance");
        require(
            block.timestamp >= stakeTimestamps[msg.sender] + LOCK_DURATION,
            "tokens are still locked"
        );

        uint256 reward = pendingReward(msg.sender);
        stakedBalances[msg.sender] -= amount;
        totalStaked -= amount;
        rewardSnapshots[msg.sender] = 0;

        if (stakedBalances[msg.sender] > 0) {
            stakeTimestamps[msg.sender] = block.timestamp;
        } else {
            stakeTimestamps[msg.sender] = 0;
        }

        bool success = stakingToken.transfer(msg.sender, amount);
        require(success, "withdraw transfer failed");

        if (reward > 0) {
            require(rewardPool >= reward, "insufficient reward pool");
            rewardPool -= reward;
            success = stakingToken.transfer(msg.sender, reward);
            require(success, "reward transfer failed");
        }

        emit Withdrawn(msg.sender, amount);
    }

    function emergencyWithdraw() external {
        uint256 amount = stakedBalances[msg.sender];
        require(amount > 0, "nothing staked");

        stakedBalances[msg.sender] = 0;
        rewardSnapshots[msg.sender] = 0;
        stakeTimestamps[msg.sender] = 0;
        totalStaked -= amount;

        bool success = stakingToken.transfer(msg.sender, amount);
        require(success, "emergency withdraw failed");

        emit EmergencyWithdrawn(msg.sender, amount);
    }

    function fundRewards(uint256 amount) external onlyOwner {
        require(amount > 0, "amount must be greater than 0");
        require(
            stakingToken.allowance(msg.sender, address(this)) >= amount,
            "approve token first"
        );

        bool success = stakingToken.transferFrom(msg.sender, address(this), amount);
        require(success, "fund transfer failed");

        rewardPool += amount;
        emit RewardFunded(amount);
    }

    function stakedBalance(address account) external view returns (uint256) {
        return stakedBalances[account];
    }

    function pendingReward(address account) public view returns (uint256) {
        uint256 staked = stakedBalances[account];
        if (staked == 0 || stakeTimestamps[account] == 0) {
            return rewardSnapshots[account];
        }

        uint256 elapsed = block.timestamp - stakeTimestamps[account];
        uint256 newReward = (staked * REWARD_RATE_PER_SECOND * elapsed) / 1e18;
        return rewardSnapshots[account] + newReward;
    }

    function unlockTime(address account) external view returns (uint256) {
        if (stakeTimestamps[account] == 0) {
            return 0;
        }
        return stakeTimestamps[account] + LOCK_DURATION;
    }

    function contractTokenBalance() external view returns (uint256) {
        return stakingToken.balanceOf(address(this));
    }
}
