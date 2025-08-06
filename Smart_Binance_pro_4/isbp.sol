// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./SBPLibrary.sol";

interface ISbpController {
    function canWithdrawSBP(address contractAddress, uint256 amount) external view returns (bool);
}

contract SbpControllerDAO is ReentrancyGuard, ISbpController {
    address public admin;
    uint256 public constant MIN_APPROVALS = 1_000; // Minimum 1,000 approvals
    uint256 public constant VOTING_PERIOD = 7 days; // Voting period

    mapping(address => SBPLibrary.Node) private users; // User data
    mapping(uint256 => WithdrawalProposal) public proposals; // Withdrawal proposals
    uint256 public proposalCount; // Proposal counter
    mapping(address => mapping(uint256 => bool)) private hasVoted; // Voters
    mapping(address => uint256) private lastUserId;
    mapping(bytes32 => address) private referralCodeToAddress;
    mapping(address => address) private uplines;
    mapping(uint256 => address) public idToAddress;

    struct WithdrawalProposal {
        address contractAddress; // Requesting contract
        uint256 amount; // Withdrawal amount
        uint256 voteCount; // Number of votes
        uint256 createdAt; // Creation timestamp
        bool executed; // Whether executed
    }

    event WithdrawalProposed(uint256 indexed proposalId, address indexed contractAddress, uint256 amount, uint256 createdAt);
    event Voted(address indexed voter, uint256 indexed proposalId);
    event WithdrawalApproved(uint256 indexed proposalId, address indexed contractAddress, uint256 amount);
    event WithdrawalRejected(uint256 indexed proposalId);

    constructor() {
        admin = msg.sender;
        lastUserId[admin] = 1;
        bytes32 leftCode = SBPLibrary.generateReferralCode(admin, "left");
        bytes32 rightCode = SBPLibrary.generateReferralCode(admin, "right");
        users[admin] = SBPLibrary.Node({
            id: 1,
            leftReferralCode: leftCode,
            rightReferralCode: rightCode,
            plusInvestment: 0,
            proInvestment: 0,
            totalLeftCount: 0,
            totalRightCount: 0,
            addressChangeCount: 0,
            isLeft: false,
            plusLeft: 0,
            plusRight: 0,
            proLeft: 0,
            proRight: 0,
            weeklyLeft: 0,
            weeklyRight: 0
        });
        idToAddress[1] = admin;
        referralCodeToAddress[leftCode] = admin;
        referralCodeToAddress[rightCode] = admin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this");
        _;
    }

    // Register user (for compatibility with Smart_Binance_Pro_4)
    function registerUser(address user, bytes32 referralCode, address upline) external onlyAdmin {
        require(users[user].id == 0, "User already registered");
        require(upline != address(0) && upline != user, "Invalid referral");
        require(users[upline].id != 0, "Upline not registered");

        lastUserId[user]++;
        bytes32 leftCode = SBPLibrary.generateReferralCode(user, "left");
        bytes32 rightCode = SBPLibrary.generateReferralCode(user, "right");
        bool isLeft = SBPLibrary.isLeftSide(upline, referralCode, users, referralCodeToAddress);

        users[user] = SBPLibrary.Node({
            id: lastUserId[user],
            leftReferralCode: leftCode,
            rightReferralCode: rightCode,
            plusInvestment: 0,
            proInvestment: 0,
            totalLeftCount: 0,
            totalRightCount: 0,
            addressChangeCount: 0,
            isLeft: isLeft,
            plusLeft: 0,
            plusRight: 0,
            proLeft: 0,
            proRight: 0,
            weeklyLeft: 0,
            weeklyRight: 0
        });
        uplines[user] = upline;
        idToAddress[lastUserId[user]] = user;
        referralCodeToAddress[leftCode] = user;
        referralCodeToAddress[rightCode] = user;
    }

    // Propose withdrawal
    function proposeWithdrawal(address contractAddress, uint256 amount) external onlyAdmin nonReentrant {
        require(amount > 0, "Amount must be greater than zero");

        proposalCount++;
        WithdrawalProposal storage proposal = proposals[proposalCount];
        proposal.contractAddress = contractAddress;
        proposal.amount = amount;
        proposal.createdAt = block.timestamp;
        proposal.executed = false;
        proposal.voteCount = 0;

        emit WithdrawalProposed(proposalCount, contractAddress, amount, block.timestamp);
    }

    // Vote on proposal
    function voteOnProposal(uint256 proposalId) external nonReentrant {
        require(users[msg.sender].id != 0, "Only registered users can vote");
        WithdrawalProposal storage proposal = proposals[proposalId];
        require(proposal.createdAt > 0, "Proposal does not exist");
        require(!proposal.executed, "Proposal already executed");
        require(block.timestamp <= proposal.createdAt + VOTING_PERIOD, "Voting period ended");
        require(!hasVoted[msg.sender][proposalId], "Already voted");

        hasVoted[msg.sender][proposalId] = true;
        proposal.voteCount++;

        emit Voted(msg.sender, proposalId);

        if (proposal.voteCount >= MIN_APPROVALS) {
            proposal.executed = true;
            emit WithdrawalApproved(proposalId, proposal.contractAddress, proposal.amount);
        }
    }

    // Check if withdrawal is allowed (implements ISbpController)
    function canWithdrawSBP(address contractAddress, uint256 amount) external view override returns (bool) {
        for (uint256 i = 1; i <= proposalCount; i++) {
            WithdrawalProposal storage proposal = proposals[i];
            if (
                proposal.contractAddress == contractAddress &&
                proposal.amount == amount &&
                proposal.executed &&
                proposal.voteCount >= MIN_APPROVALS &&
                block.timestamp <= proposal.createdAt + VOTING_PERIOD
            ) {
                return true;
            }
        }
        return false;
    }

    // Reject old or failed proposals
    function rejectOldProposal(uint256 proposalId) external nonReentrant {
        WithdrawalProposal storage proposal = proposals[proposalId];
        require(proposal.createdAt > 0, "Proposal does not exist");
        require(!proposal.executed, "Proposal already executed");
        require(block.timestamp > proposal.createdAt + VOTING_PERIOD, "Voting period not ended");

        proposal.executed = true; // Prevent reuse
        emit WithdrawalRejected(proposalId);
    }
}