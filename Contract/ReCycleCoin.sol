// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ReCycleCoin Smart Waste Management
 * @dev A blockchain-based reward system that incentivizes users for proper waste disposal using ReCycleCoins.
 */
contract ReCycleCoin {
    address public owner;

    struct User {
        uint256 totalWasteCollected;
        uint256 rewardBalance;
    }

    mapping(address => User) public users;

    event WasteSubmitted(address indexed user, uint256 weight, uint256 reward);
    event RewardRedeemed(address indexed user, uint256 amount);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Allows users to submit waste data and earn ReCycleCoin rewards.
     * @param _wasteWeight Weight of waste submitted (in kilograms).
     */
    function submitWaste(uint256 _wasteWeight) external {
        require(_wasteWeight > 0, "Invalid waste weight");

        uint256 reward = _wasteWeight * 10; // 10 tokens per kg
        users[msg.sender].totalWasteCollected += _wasteWeight;
        users[msg.sender].rewardBalance += reward;

        emit WasteSubmitted(msg.sender, _wasteWeight, reward);
    }

    /**
     * @dev Users can redeem their earned ReCycleCoins.
     * @param _amount Amount of ReCycleCoins to redeem.
     */
    function redeemRewards(uint256 _amount) external {
        require(users[msg.sender].rewardBalance >= _amount, "Insufficient balance");
        users[msg.sender].rewardBalance -= _amount;

        emit RewardRedeemed(msg.sender, _amount);
    }

    /**
     * @dev Owner can transfer contract ownership.
     * @param _newOwner Address of the new contract owner.
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        address oldOwner = owner;
        owner = _newOwner;

        emit OwnershipTransferred(oldOwner, _newOwner);
    }
}
