// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BasicTimeLock
 * @dev A simple time lock contract that restricts withdrawals until a specified time
 * @notice Allows only the owner to withdraw after the unlock time has passed
 */
contract BasicTimeLock {
    // State variables
    address public owner;          // Address of the contract owner
    uint256 public unlockTime;     // Timestamp when funds become withdrawable
    uint public startTime;         // Timestamp when contract was deployed
    
    /**
     * @dev Initializes the contract with lock duration
     * @param _unlockTime Duration in seconds until funds can be withdrawn
     */
    constructor(uint256 _unlockTime) {
        owner = msg.sender;
        startTime = block.timestamp;
        unlockTime = block.timestamp + _unlockTime;
    }
    
    /**
     * @dev Modifier to restrict function access to contract owner only
     */
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    /**
     * @dev Allows owner to withdraw after lock period expires
     * @notice Emits WithdrawalAttempt event with owner address and timestamp
     * @notice Requires current time to be past unlockTime
     */
    function withdraw() external onlyOwner {
        require(block.timestamp >= unlockTime, "Funds are still locked");
        emit WithdrawalAttempt(owner, block.timestamp);
    }
    
    /**
     * @dev Returns remaining time until unlock
     * @return uint256 Remaining seconds until unlock (0 if already unlocked)
     */
    function getTimeLeft() external view returns (uint256) {
        return block.timestamp >= unlockTime ? 0 : unlockTime - block.timestamp;
    }

    /**
     * @dev Emitted when owner attempts to withdraw funds
     * @param owner Address initiating the withdrawal
     * @param timestamp Block timestamp of withdrawal attempt
     */
    event WithdrawalAttempt(address indexed owner, uint256 timestamp);
}
