// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title TimeLock
 * @dev A smart contract that locks ETH deposits until a specified unlock time
 * @notice Allows only the owner to withdraw funds after the lock period expires
 */
contract TimeLock {
    // State variables
    address public owner;          // Address of the contract owner
    uint256 public unlockTime;     // Timestamp when funds become withdrawable
    bool public locked;            // Lock status of the contract
    
    // Events
    event Deposit(address indexed depositor, uint256 amount, uint256 unlockTime);
    event Withdrawal(address indexed recipient, uint256 amount);
    
    // Modifiers
    /**
     * @dev Restricts function access to contract owner only
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    /**
     * @dev Ensures funds are currently locked
     */
    modifier isLocked() {
        require(locked, "Funds are not currently locked");
        _;
    }
    
    /**
     * @dev Ensures lock period has expired
     */
    modifier isUnlocked() {
        require(block.timestamp >= unlockTime, "Funds are still locked");
        _;
    }
    
    /**
     * @dev Initializes the contract with lock duration
     * @param _unlockDuration Duration in seconds until funds can be withdrawn
     */
    constructor(uint256 _unlockDuration) {
        owner = msg.sender;
        unlockTime = block.timestamp + _unlockDuration;
        locked = true;
    }
    
    /**
     * @dev Fallback function to accept ETH deposits
     */
    receive() external payable {
        deposit();
    }
    
    /**
     * @dev Allows ETH deposits to the contract
     * @notice Emits Deposit event with transaction details
     * @notice Requires non-zero ETH amount
     */
    function deposit() public payable {
        require(msg.value > 0, "Must send some ETH");
        emit Deposit(msg.sender, msg.value, unlockTime);
    }
    
    /**
     * @dev Withdraws all locked ETH to owner address
     * @notice Only callable by owner after lock period expires
     * @notice Emits Withdrawal event on success
     * @notice Updates locked status to false after withdrawal
     */
    function withdraw() external onlyOwner isLocked isUnlocked {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        locked = false;
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(owner, balance);
    }
    
    /**
     * @dev Extends the lock period by additional time
     * @param additionalTime Seconds to add to current unlockTime
     * @notice Only callable by owner while contract is locked
     */
    function extendLock(uint256 additionalTime) external onlyOwner isLocked {
        require(additionalTime > 0, "Must add some time");
        unlockTime += additionalTime;
    }
    
    /**
     * @dev Returns current contract ETH balance
     * @return uint256 Current balance in wei
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Calculates remaining time until unlock
     * @return uint256 Remaining seconds until unlock (0 if already unlocked)
     */
    function timeRemaining() external view returns (uint256) {
        if (block.timestamp >= unlockTime) return 0;
        return unlockTime - block.timestamp;
    }
}
