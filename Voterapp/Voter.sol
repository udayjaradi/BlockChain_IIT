// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title VotingSystem
 * @dev A smart contract for managing a simple voting system where:
 * - Owner can add candidates
 * - Users can vote once
 * - Winner can be retrieved
 */
contract VotingSystem {
    // State Variables
    address public owner; // Contract owner address
    mapping(address => bool) public hasVoted; // Tracks which addresses have voted
    mapping(string => uint256) public votesReceived; // Tracks votes per candidate
    string[] public candidateList; // Array of all candidates

    /**
     * @dev Contract constructor sets the deployer as owner
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Modifier to restrict function access to owner only
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    /**
     * @dev Adds a new candidate to the voting system
     * @param candidate Name of the candidate to add
     * Requirements:
     * - Only owner can call this function
     * - Candidate name cannot be empty
     */
    function addCandidate(string memory candidate) public onlyOwner {
        require(bytes(candidate).length > 0, "Candidate name cannot be empty");
        votesReceived[candidate] = 0; // Initialize vote count to 0
        candidateList.push(candidate); // Add to candidate list
    }

    /**
     * @dev Allows a user to vote for a candidate
     * @param candidate Name of the candidate to vote for
     * Requirements:
     * - Voter hasn't voted before
     * - Candidate must exist
     */
    function vote(string memory candidate) public {
        require(!hasVoted[msg.sender], "You have already voted");
        require(votesReceived[candidate] >= 0, "Invalid candidate");

        hasVoted[msg.sender] = true; // Mark voter as voted
        votesReceived[candidate] += 1; // Increment candidate's vote count
    }

    /**
     * @dev Calculates and returns the winning candidate
     * @return winner Name of the candidate with most votes
     * Note: In case of tie, returns first candidate with highest votes
     */
    function getWinner() public view returns (string memory winner) {
        uint256 winningVoteCount = 0;
        
        // Iterate through all candidates to find the one with most votes
        for (uint i = 0; i < candidateList.length; i++) {
            if (votesReceived[candidateList[i]] > winningVoteCount) {
                winningVoteCount = votesReceived[candidateList[i]];
                winner = candidateList[i];
            }
        }
    }
}
