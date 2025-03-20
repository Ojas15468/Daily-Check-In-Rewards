pragma solidity ^0.8.0;

contract DailyLoginReward {
    // Track last login timestamp for each user
    mapping(address => uint256) public lastLogin;
    
    // Store total rewards earned by each user
    mapping(address => uint256) public userRewards;
    
    // Fixed reward amount per daily login (in wei)
    uint256 public constant REWARD_AMOUNT = 1 ether;
    
    // Minimum time between rewards (1 day = 86400 seconds)
    uint256 public constant COOLDOWN_PERIOD = 86400;
    
    // Event to log successful reward claims
    event RewardClaimed(address indexed user, uint256 amount, uint256 timestamp);
    
    // Function to claim daily reward
    function claimReward() external {
        address user = msg.sender;
        uint256 currentTime = block.timestamp;
        
        // Check if user can claim (first login or cooldown passed)
        require(
            lastLogin[user] == 0 || 
            currentTime >= lastLogin[user] + COOLDOWN_PERIOD,
            "Cooldown period not elapsed"
        );
        
        // Update user's last login timestamp
        lastLogin[user] = currentTime;
        
        // Add reward to user's balance
        userRewards[user] += REWARD_AMOUNT;
        
        // Emit event for tracking
        emit RewardClaimed(user, REWARD_AMOUNT, currentTime);
    }
    
    // Function to check user's reward balance
    function getRewardBalance() external view returns (uint256) {
        return userRewards[msg.sender];  // Fixed: Changed 'user' to 'msg.sender'
    }
    
    // Function to check time until next reward eligibility
    function timeUntilNextReward() external view returns (uint256) {
        address user = msg.sender;
        if (lastLogin[user] == 0) {
            return 0;
        }
        
        uint256 nextEligibleTime = lastLogin[user] + COOLDOWN_PERIOD;
        if (block.timestamp >= nextEligibleTime) {
            return 0;
        }
        
        return nextEligibleTime - block.timestamp;
    }
}
