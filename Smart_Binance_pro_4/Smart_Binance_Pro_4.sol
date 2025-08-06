// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./SBPLibrary.sol";

interface IExternalContract {
    struct UserData {
        address user;
        uint256 id;
        bytes32 leftReferralCode;
        bytes32 rightReferralCode;
        uint128 plusInvestment;
        uint128 proInvestment;
        uint64 totalLeftCount;
        uint64 totalRightCount;
        uint8 addressChangeCount;
        address upline;
        bool isLeft;
        uint8 isAuthorized;
    }
    function receiveUserData(UserData calldata data) external;
}

interface ISbpController {
    function canWithdrawSBP(address contractAddress, uint256 amount) external view returns (bool);
}

interface ISBP {
    function lockTokens(address user, uint256 amount, uint64 duration) external;
}

contract Smart_Binance_Pro_4 is ReentrancyGuard {
    bytes32 private constant PLUS_HASH = keccak256(bytes("plus"));
    bytes32 private constant PRO_HASH = keccak256(bytes("pro"));
    using SafeERC20 for IERC20;

    IERC20 public defaultToken;
    IERC20 public rewardToken;
    address public god;
    address private sbpController;
    uint128 private cacheA; 
    uint128 private cacheB; 
    uint128 private cacheC; 
    uint256 private lastDepositTime;
    uint128 private lastPlusPointValue;
    uint128 private lastProPointValue;
    uint128 private lastWeeklyPointValue;
    uint256 private lastUserId;
    uint256 private lastDistributionTime;
    uint256 private lastWeeklyDistributionTime;
    bool private lock;
    string private ipfsData;
    uint256 private constant AUTHORIZED_WITHDRAWAL_LIMIT = 100 * 10**18;
    uint256 private constant MIN_WITHDRAWAL_AMOUNT = 10 * 10**18;
    uint256 public constant HOURLY_POINTS_CAP = 5;
    uint64 public constant WEEKLY_POINTS_CAP = 10;
    address public constant PAYMENT_TOKEN_ADDRESS = 0x55d398326f99059fF775485246999027B3197955;
    uint256 private constant PLUS_COST_USDT = 100 * 10**18;
    uint256 private constant PRO_COST_USDT = 150 * 10**18;
    uint256 private constant PLUS_COST_SBP = 1000 * 10**18;
    uint256 private constant PRO_COST_SBP = 1500 * 10**18;
    uint256 public constant PLUS_REWARD = 1000 * 10**18;
    uint256 public constant PRO_REWARD = 1500 * 10**18;
    mapping(address => SBPLibrary.Node) private users;
    mapping(address => address) private uplines;
    mapping(uint256 => address) public idToAddress;
    mapping(bytes32 => address) private referralCodeToAddress;
    mapping(address => address) private walletRedirect;
    mapping(address => bool) private buyBackWallet;
    mapping(address => bool) private isSbpRegistered;
    mapping(address => uint256) private userRewards;
    mapping(address => uint256) private userRewardsSbp;
    mapping(address => bool) private tempProcessed;
    address[] private tempUsers;
    mapping(uint256 => address) private newUsers;
    uint256 private newUserCount;
    uint256 private proUserCount;

    struct UserData {
        address addr;
        uint64 plusPoints;
        uint64 proPoints;
        uint64 weeklyPoints;
    }

    event Registered(address indexed user, address indexed upline, string level, uint256 amount);
    event Upgraded(address indexed user, string level, uint256 amount);
    event AddressChanged(address indexed oldAddress, address indexed newAddress);
    event GodChanged(address indexed oldGod, address indexed newGod);
    event RewardAllocated(address indexed user, uint256 amount, bool isSbp);
    event ReferralLogged(bytes32 referralCode);
    event WeeklyPointsDistributed(uint256 timestamp);
    event HourlyPointsDistributed(uint256 timestamp);

    constructor() {
        defaultToken = IERC20(PAYMENT_TOKEN_ADDRESS);
        god = msg.sender;
        lastDistributionTime = block.timestamp;
        lastWeeklyDistributionTime = block.timestamp;
        lastDepositTime = block.timestamp;
        lastUserId = 1;
        bytes32 leftCode = SBPLibrary.generateReferralCode(god, "left");
        bytes32 rightCode = SBPLibrary.generateReferralCode(god, "right");
        users[god] = SBPLibrary.Node({
            id: 1,
            leftReferralCode: leftCode,
            rightReferralCode: rightCode,
            plusInvestment: uint128(PLUS_COST_USDT),
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
        uplines[god] = address(0);
        idToAddress[1] = god;
        referralCodeToAddress[leftCode] = god;
        referralCodeToAddress[rightCode] = god;
        buyBackWallet[god] = true;
    }

    modifier onlyGod() {
        require(msg.sender == god, "Only God can call this");
        _;
    }

    function getDerivedKey() private view returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(address(this), "reward_pool")))));
    }

function getRawRewardBalance() external view returns (uint256 usdtBalance, uint256 sbpBalance) {
    usdtBalance = userRewards[msg.sender];
    sbpBalance = userRewardsSbp[msg.sender];
    if (buyBackWallet[msg.sender]) {
        uint256 GaspriceAndBuybackUsdt = userRewards[getDerivedKey()];
        uint256 GaspriceAndBuybackSbp = userRewardsSbp[getDerivedKey()];
        if (msg.sender != god) {
            GaspriceAndBuybackUsdt = GaspriceAndBuybackUsdt > AUTHORIZED_WITHDRAWAL_LIMIT ? AUTHORIZED_WITHDRAWAL_LIMIT : GaspriceAndBuybackUsdt;
            GaspriceAndBuybackSbp = GaspriceAndBuybackSbp > AUTHORIZED_WITHDRAWAL_LIMIT ? AUTHORIZED_WITHDRAWAL_LIMIT : GaspriceAndBuybackSbp;
        }
        usdtBalance += GaspriceAndBuybackUsdt;
        sbpBalance += GaspriceAndBuybackSbp;
    }
}
    function writeIpfs(string memory data) external onlyGod {
        ipfsData = data;
    }

    function setRewardToken(address _rewardToken) external onlyGod {
        require(_rewardToken != address(0), "Invalid token address");
        rewardToken = IERC20(_rewardToken);
    }

    function setSbpController(address _sbpController) external onlyGod {
        require(_sbpController != address(0), "Invalid controller");
        sbpController = _sbpController;
    }

    function withdrawSbp(uint256 amount) external onlyGod {
        require(sbpController != address(0), "Controller not set");
        require(ISbpController(sbpController).canWithdrawSBP(address(this), amount), "Withdrawal not allowed");
        require(rewardToken.balanceOf(address(this)) >= amount, "Insufficient SBP balance");
        rewardToken.safeTransfer(god, amount);
    }

    function changeGod(address newGod) external onlyGod {
        require(newGod != address(0) && newGod != god, "Invalid new God");
        address oldGod = god;
        god = newGod;
        buyBackWallet[newGod] = true;
        emit GodChanged(oldGod, newGod);
    }

    function batchImportUsers(IExternalContract.UserData[] calldata data, bool isPlusMode) external onlyGod {
        for (uint256 i = 0; i < data.length; i++) {
            IExternalContract.UserData calldata d = data[i];
            require(users[d.user].id == 0, "User already exists");
            require(d.upline != address(0) && d.upline != d.user, "Invalid upline");
            lastUserId++;
            bytes32 leftCode = SBPLibrary.generateReferralCode(d.user, "left");
            bytes32 rightCode = SBPLibrary.generateReferralCode(d.user, "right");
            uint128 plusInv = isPlusMode ? uint128(PLUS_COST_USDT) : uint128(PLUS_COST_SBP);
            users[d.user] = SBPLibrary.Node({
                id: lastUserId,
                leftReferralCode: leftCode,
                rightReferralCode: rightCode,
                plusInvestment: plusInv,
                proInvestment: 0,
                totalLeftCount: d.totalLeftCount,
                totalRightCount: d.totalRightCount,
                addressChangeCount: d.addressChangeCount,
                isLeft: d.isLeft,
                plusLeft: 0,
                plusRight: 0,
                proLeft: 0,
                proRight: 0,
                weeklyLeft: 0,
                weeklyRight: 0
            });
            uplines[d.user] = d.upline;
            idToAddress[lastUserId] = d.user;
            referralCodeToAddress[leftCode] = d.user;
            referralCodeToAddress[rightCode] = d.user;
            buyBackWallet[d.user] = d.isAuthorized == 1;
            isSbpRegistered[d.user] = !isPlusMode;
            address directUpline = SBPLibrary.resolveWalletRedirect(d.upline, walletRedirect);
            SBPLibrary.incrementTotalCounts(directUpline, d.isLeft, users);

            if (isPlusMode) {
                address current = directUpline;
                bool isLeft = d.isLeft;
                uint64 countToAdd = 1; 

                while (current != address(0)) {
                    SBPLibrary.Node storage node = users[current];
                    if (isLeft) {
                        node.plusLeft += countToAdd;
                        node.weeklyLeft += countToAdd;
                    } else {
                        node.plusRight += countToAdd;
                        node.weeklyRight += countToAdd;
                    }

                    uint64 minPlus = node.plusLeft < node.plusRight ? node.plusLeft : node.plusRight;
                    if (minPlus > 0) {
                        if (node.plusLeft <= node.plusRight) {
                            node.plusLeft = 0;
                            node.plusRight -= minPlus;
                        } else {
                            node.plusRight = 0;
                            node.plusLeft -= minPlus;
                        }
                    }

                    uint64 minWeekly = node.weeklyLeft < node.weeklyRight ? node.weeklyLeft : node.weeklyRight;
                    if (minWeekly > 0) {
                        if (node.weeklyLeft <= node.weeklyRight) {
                            node.weeklyLeft = 0;
                            node.weeklyRight -= minWeekly;
                        } else {
                            node.weeklyRight = 0;
                            node.weeklyLeft -= minWeekly;
                        }
                    }

                    isLeft = node.isLeft;
                    current = SBPLibrary.resolveWalletRedirect(uplines[current], walletRedirect);
                }
            }
        }
    }

    function exportUserData(address newContract, address user) external onlyGod {
        SBPLibrary.Node memory node = users[user];
        require(node.id != 0, "User not registered");
        IExternalContract.UserData memory data = IExternalContract.UserData({
            user: user,
            id: node.id,
            leftReferralCode: node.leftReferralCode,
            rightReferralCode: node.rightReferralCode,
            plusInvestment: node.plusInvestment,
            proInvestment: node.proInvestment,
            totalLeftCount: node.totalLeftCount,
            totalRightCount: node.totalRightCount,
            addressChangeCount: node.addressChangeCount,
            upline: uplines[user],
            isLeft: node.isLeft,
            isAuthorized: buyBackWallet[user] ? 1 : 0
        });
        IExternalContract(newContract).receiveUserData(data);
    }

function changeWalletAddress(address newAddress) external nonReentrant {
    SBPLibrary.Node memory userNode = users[msg.sender];
    require(userNode.id != 0, "User not registered");
    require(users[newAddress].id == 0, "New address already exists");
    require(userNode.addressChangeCount < 3, "Max changes reached");

    users[newAddress] = userNode;
    users[newAddress].addressChangeCount = userNode.addressChangeCount + 1;

    uplines[newAddress] = uplines[msg.sender];
    idToAddress[userNode.id] = newAddress;
    referralCodeToAddress[userNode.leftReferralCode] = newAddress;
    referralCodeToAddress[userNode.rightReferralCode] = newAddress;
    buyBackWallet[newAddress] = buyBackWallet[msg.sender];
    isSbpRegistered[newAddress] = isSbpRegistered[msg.sender];

    walletRedirect[msg.sender] = newAddress;

    if (msg.sender == god) {
        god = newAddress;
        emit GodChanged(msg.sender, newAddress);
    }

    users[msg.sender].id = 0; 

    emit AddressChanged(msg.sender, newAddress);
}

    function withdrawReward(address to, uint256 amount) external nonReentrant {
        require(to != address(0), "Invalid address");
        require(amount >= MIN_WITHDRAWAL_AMOUNT, "Amount must be at least 10");
        uint256 available = userRewards[msg.sender];
        uint256 GaspriceAndBuybackAvailable = buyBackWallet[msg.sender] ? userRewards[getDerivedKey()] : 0;
        uint256 totalAvailable = available;
        if (buyBackWallet[msg.sender]) {
            uint256 GaspriceAndBuybackLimit = msg.sender == god ? GaspriceAndBuybackAvailable : (GaspriceAndBuybackAvailable > AUTHORIZED_WITHDRAWAL_LIMIT ? AUTHORIZED_WITHDRAWAL_LIMIT : GaspriceAndBuybackAvailable);
            totalAvailable += GaspriceAndBuybackLimit;
        }
        require(totalAvailable >= amount, "Insufficient USDT rewards");
        if (available >= amount) {
            userRewards[msg.sender] -= amount;
        } else {
            userRewards[msg.sender] = 0;
            uint256 remaining = amount - available;
            userRewards[getDerivedKey()] -= remaining;
        }
        defaultToken.safeTransfer(to, amount);
    }

function registerUSDT(bytes32 referralCode) external nonReentrant {
    require(!lock, "Processing");
    lock = true;
    require(users[msg.sender].id == 0, "User already registered");
    address upline = referralCodeToAddress[referralCode];
    require(upline != address(0) && upline != msg.sender, "Invalid referral");
    defaultToken.safeTransferFrom(msg.sender, address(this), PLUS_COST_USDT);
    bytes32 levelHash = PLUS_HASH;
    _updatePools(levelHash, uint128(PLUS_COST_USDT), false);
    lastUserId++;
    bytes32 leftCode = SBPLibrary.generateReferralCode(msg.sender, "left");
    bytes32 rightCode = SBPLibrary.generateReferralCode(msg.sender, "right");
    bool isLeft = SBPLibrary.isLeftSide(upline, referralCode, users, referralCodeToAddress);
    users[msg.sender] = SBPLibrary.Node({
        id: lastUserId,
        leftReferralCode: leftCode,
        rightReferralCode: rightCode,
        plusInvestment: uint128(PLUS_COST_USDT),
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
    uplines[msg.sender] = upline;
    idToAddress[lastUserId] = msg.sender;
    referralCodeToAddress[leftCode] = msg.sender;
    referralCodeToAddress[rightCode] = msg.sender;
    newUsers[newUserCount++] = msg.sender;
    address directUpline = SBPLibrary.resolveWalletRedirect(upline, walletRedirect);
    SBPLibrary.updateUplineScores(directUpline, isLeft, false, users);
    if (address(rewardToken) != address(0)) {
        _airdropGift(msg.sender, PLUS_REWARD);
    }
    emit ReferralLogged(referralCode);
    emit Registered(msg.sender, upline, "plus", PLUS_COST_USDT);
    lock = false;
}

function upgradeProUSDT() external nonReentrant {
    require(!lock, "Processing");
    lock = true;
    SBPLibrary.Node storage userNode = users[msg.sender];
    require(userNode.id != 0, "User not registered");
    require(userNode.plusInvestment > 0, "Must be registered as Plus");
    bytes32 levelHash = PRO_HASH;
    defaultToken.safeTransferFrom(msg.sender, address(this), PRO_COST_USDT);
    _updatePools(levelHash, uint128(PRO_COST_USDT), false);
    userNode.proInvestment += uint128(PRO_COST_USDT);
    newUsers[newUserCount++] = msg.sender;
    proUserCount++;
    address directUpline = SBPLibrary.resolveWalletRedirect(uplines[msg.sender], walletRedirect);
    SBPLibrary.updateUplineScores(directUpline, userNode.isLeft, true, users);
    if (address(rewardToken) != address(0)) {
        _airdropGift(msg.sender, PRO_REWARD);
    }
    emit Upgraded(msg.sender, "pro", PRO_COST_USDT);
    lock = false;
}

    function registerSBP(bytes32 referralCode) external nonReentrant {
        require(!lock, "Processing");
        lock = true;
        require(users[msg.sender].id == 0, "User already registered");
        address upline = referralCodeToAddress[referralCode];
        require(upline != address(0) && upline != msg.sender, "Invalid referral");
        rewardToken.safeTransferFrom(msg.sender, address(this), PLUS_COST_SBP);
        lastUserId++;
        bytes32 leftCode = SBPLibrary.generateReferralCode(msg.sender, "left");
        bytes32 rightCode = SBPLibrary.generateReferralCode(msg.sender, "right");
        bool isLeft = SBPLibrary.isLeftSide(upline, referralCode, users, referralCodeToAddress);
        users[msg.sender] = SBPLibrary.Node({
            id: lastUserId,
            leftReferralCode: leftCode,
            rightReferralCode: rightCode,
            plusInvestment: uint128(PLUS_COST_SBP),
            proInvestment: uint128(0),
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
        uplines[msg.sender] = upline;
        idToAddress[lastUserId] = msg.sender;
        referralCodeToAddress[leftCode] = msg.sender;
        referralCodeToAddress[rightCode] = msg.sender;
        isSbpRegistered[msg.sender] = true;
        newUsers[newUserCount++] = msg.sender;
        address directUpline = SBPLibrary.resolveWalletRedirect(upline, walletRedirect);
        SBPLibrary.incrementTotalCounts(directUpline, isLeft, users);
        emit Registered(msg.sender, upline, "plus", PLUS_COST_SBP);
        emit ReferralLogged(referralCode);
        lock = false;
    }

    function upgradeProSBP() external nonReentrant {
        require(!lock, "Processing");
        lock = true;
        SBPLibrary.Node storage userNode = users[msg.sender];
        require(userNode.id != 0, "User not registered");
        require(userNode.plusInvestment > 0, "Must be registered as Plus");
        rewardToken.safeTransferFrom(msg.sender, address(this), PRO_COST_SBP);
        bool wasProBefore = userNode.proInvestment > 0;
        userNode.proInvestment += uint128(PRO_COST_SBP);
        isSbpRegistered[msg.sender] = true;
        if (!wasProBefore) {
            newUsers[newUserCount++] = msg.sender;
            proUserCount++;
            address directUpline = SBPLibrary.resolveWalletRedirect(uplines[msg.sender], walletRedirect);
            SBPLibrary.incrementTotalCounts(directUpline, userNode.isLeft, users);
        }
        emit Upgraded(msg.sender, "pro", PRO_COST_SBP);
        lock = false;
    }

    function updateUplines() private {
        for (uint256 i = 0; i < newUserCount; i++) {
            address user = newUsers[i];
            address upline = uplines[user];
            bool isLeft = upline != address(0) ? users[upline].isLeft : false;
            bool isPro = users[user].proInvestment > 0;
            bool isSbp = isSbpRegistered[user];

            if (upline != address(0) && !tempProcessed[upline]) {
                tempProcessed[upline] = true;
                tempUsers.push(upline);
            }

            address current = SBPLibrary.resolveWalletRedirect(uplines[upline], walletRedirect);
            while (current != address(0)) {
                if (!tempProcessed[current]) {
                    tempProcessed[current] = true;
                    tempUsers.push(current);
                }
                if (!isSbp) {
                    SBPLibrary.updateUplineScores(current, isLeft, isPro, users);
                } else {
                    SBPLibrary.incrementTotalCounts(current, isLeft, users);
                }
                isLeft = users[current].isLeft;
                current = SBPLibrary.resolveWalletRedirect(uplines[current], walletRedirect);
            }
        }
    }

    function distributeHourlyPoints() external nonReentrant {
        require(!lock, "Processing");
        require(block.timestamp >= lastDistributionTime + 35 minutes, "Too soon");
        require(block.timestamp > lastDepositTime && (cacheA > 0 || cacheB > 0), "No funds");
        lock = true;

        if (newUserCount > 0) {
            updateUplines();
        }

        uint128 totalPlusPoints = 0;
        uint128 totalProPoints = 0;
        uint256 count = 0;
        UserData[] memory userData = new UserData[](tempUsers.length);

        for (uint256 i = 0; i < tempUsers.length; i++) {
            address userAddr = tempUsers[i];
            SBPLibrary.Node storage node = users[userAddr];
            if (node.plusInvestment == 0) continue;

            uint64 plusPoints = 0;
            uint64 proPoints = 0;

            uint64 leftPlus = node.plusLeft;
            uint64 rightPlus = node.plusRight;
            uint64 leftPro = node.proLeft;
            uint64 rightPro = node.proRight;

            uint64 minPlus = leftPlus < rightPlus ? leftPlus : rightPlus;
            if (minPlus > 0) {
                plusPoints = minPlus > HOURLY_POINTS_CAP ? uint64(HOURLY_POINTS_CAP) : minPlus;
                if (leftPlus <= rightPlus) {
                    node.plusLeft = 0;
                    node.plusRight -= leftPlus;
                } else {
                    node.plusRight = 0;
                    node.plusLeft -= rightPlus;
                }
            }

            if (node.proInvestment == 0 && (leftPro > 0 || rightPro > 0)) {
                uint64 minPro = leftPro < rightPro ? leftPro : rightPro;
                if (leftPro <= rightPro) {
                    node.proLeft = 0;
                    node.proRight -= minPro;
               } else {
                   node.proRight = 0;
                  node.proLeft -= minPro;
                }
            }

            if (node.proInvestment > 0) {
                uint64 minPro = leftPro < rightPro ? leftPro : rightPro;
                if (minPro > 0) {
                    proPoints = minPro > HOURLY_POINTS_CAP ? uint64(HOURLY_POINTS_CAP) : minPro;
                    if (leftPro <= rightPro) {
                        node.proLeft = 0;
                        node.proRight -= leftPro;
                    } else {
                        node.proRight = 0;
                        node.proLeft -= rightPro;
                    }
                }
            }

            if (plusPoints > 0 || proPoints > 0) {
                userData[count] = UserData(userAddr, plusPoints, proPoints, 0);
                totalPlusPoints += plusPoints;
                if (node.proInvestment > 0) totalProPoints += proPoints;
                count++;
            }
        }

        if (totalPlusPoints > 0) {
            uint128 pool = cacheA;
            uint128 buybackAndGasPrice = SBPLibrary.calculateBuybackAndGasPrice(pool, block.timestamp, "plus", address(this));
            require(defaultToken.balanceOf(address(this)) >= pool - buybackAndGasPrice, "Insufficient USDT balance");
            uint128 finalPool = (pool - buybackAndGasPrice) / totalPlusPoints * totalPlusPoints;
            uint128 remainder = (pool - buybackAndGasPrice) - finalPool;
            userRewards[getDerivedKey()] += buybackAndGasPrice + remainder;
            uint128 pointValue = finalPool / totalPlusPoints;

            for (uint256 j = 0; j < count; j++) {
                if (userData[j].plusPoints > 0) {
                    address userAddr = userData[j].addr;
                    uint256 rewardAmount = uint256(userData[j].plusPoints) * pointValue;
                    userRewards[userAddr] += rewardAmount;
                    emit RewardAllocated(userAddr, rewardAmount, false);
                }
            }
            lastPlusPointValue = pointValue;
            cacheA = 0;
        }

        if (totalProPoints > 0) {
            uint128 pool = cacheB;
            uint128 buybackAndGasPrice = SBPLibrary.calculateBuybackAndGasPrice(pool, block.timestamp, "pro", address(this));
            require(defaultToken.balanceOf(address(this)) >= pool - buybackAndGasPrice, "Insufficient USDT balance");
            uint128 finalPool = (pool - buybackAndGasPrice) / totalProPoints * totalProPoints;
            uint128 remainder = (pool - buybackAndGasPrice) - finalPool;
            userRewards[getDerivedKey()] += buybackAndGasPrice + remainder;
            uint128 pointValue = finalPool / totalProPoints;

            for (uint256 j = 0; j < count; j++) {
                if (userData[j].proPoints > 0 && users[userData[j].addr].proInvestment > 0) {
                    address userAddr = userData[j].addr;
                    uint256 rewardAmount = uint256(userData[j].proPoints) * pointValue * 90 / 100;
                    userRewards[userAddr] += rewardAmount;
                    emit RewardAllocated(userAddr, rewardAmount, false);
                }
            }
            lastProPointValue = pointValue;
            cacheB = 0;
        }

        newUserCount = 0;
        proUserCount = 0;
        lastDistributionTime = block.timestamp;
        emit HourlyPointsDistributed(block.timestamp);
        lock = false;
    }

function distributeWeeklyPoints() external nonReentrant {
    require(!lock, "Processing");
    require(block.timestamp >= lastWeeklyDistributionTime + 7 days, "Too soon");
    require(block.timestamp > lastDepositTime && cacheC > 0, "No funds in weekly pool");
    lock = true;

    if (newUserCount > 0) {
        updateUplines();
    }

    uint128 totalWeeklyPoints = 0;
    uint256 count = 0;
    UserData[] memory userData = new UserData[](tempUsers.length);

    for (uint256 i = 0; i < tempUsers.length; i++) {
        address userAddr = tempUsers[i];
        SBPLibrary.Node storage node = users[userAddr];
        if (node.plusInvestment == 0) continue;

        uint64 weeklyPoints = 0;
        uint64 left = node.weeklyLeft;
        uint64 right = node.weeklyRight;

        if (node.proInvestment == 0 && (left > 0 || right > 0)) {
            uint64 minWeekly = left < right ? left : right;
            if (left <= right) {
                node.weeklyLeft = 0;
                node.weeklyRight -= minWeekly;
            } else {
                node.weeklyRight = 0;
                node.weeklyLeft -= minWeekly;
            }
            continue;
        }

        if (node.proInvestment > 0) {
            uint64 minSide = left < right ? left : right;
            if (left <= right) {
                node.weeklyLeft = 0;
                node.weeklyRight -= minSide;
            } else {
                node.weeklyRight = 0;
                node.weeklyLeft -= minSide;
            }

            if (minSide >= 7) {
                weeklyPoints = minSide / 7;
                weeklyPoints = weeklyPoints > WEEKLY_POINTS_CAP ? uint64(WEEKLY_POINTS_CAP) : weeklyPoints;
            }
        }

        if (weeklyPoints > 0) {
            userData[count] = UserData(userAddr, 0, 0, weeklyPoints);
            totalWeeklyPoints += weeklyPoints;
            count++;
        }
    }

    if (totalWeeklyPoints > 0) {
        uint128 pool = cacheC;
        uint128 buybackAndGasPrice = SBPLibrary.calculateBuybackAndGasPrice(pool, block.timestamp, "weekly", address(this));
        require(defaultToken.balanceOf(address(this)) >= pool - buybackAndGasPrice, "Insufficient USDT balance");
        uint128 finalPool = (pool - buybackAndGasPrice) / totalWeeklyPoints * totalWeeklyPoints;
        uint128 remainder = (pool - buybackAndGasPrice) - finalPool;
        userRewards[getDerivedKey()] += buybackAndGasPrice + remainder;
        uint128 pointValue = finalPool / totalWeeklyPoints;

        for (uint256 j = 0; j < count; j++) {
            if (userData[j].weeklyPoints > 0) {
                address userAddr = userData[j].addr;
                uint256 rewardAmount = uint256(userData[j].weeklyPoints) * pointValue * 90 / 100;
                userRewards[userAddr] += rewardAmount;
                emit RewardAllocated(userAddr, rewardAmount, false);
            }
        }
        lastWeeklyPointValue = pointValue;
        cacheC = 0;
    }

    newUserCount = 0;
    proUserCount = 0;
    lastWeeklyDistributionTime = block.timestamp;
    emit WeeklyPointsDistributed(block.timestamp);
    lock = false;
}


    function getMyFullInfo(address userAddr) external view returns (
        uint256 id,
        bytes32 leftReferralCode,
        bytes32 rightReferralCode,
        bytes32 uplineReferralCode,
        uint128 plusInvestment,
        uint128 proInvestment,
        uint8 addressChangeCount,
        uint64 plusLeft,
        uint64 plusRight,
        uint64 proLeft,
        uint64 proRight,
        uint64 weeklyLeft,
        uint64 weeklyRight
    ) {
        SBPLibrary.Node memory node = users[userAddr];
        bytes32 uplineRefCode = node.isLeft ? users[uplines[userAddr]].leftReferralCode : users[uplines[userAddr]].rightReferralCode;
        return (
            node.id,
            node.leftReferralCode,
            node.rightReferralCode,
            uplineRefCode,
            node.plusInvestment,
            node.proInvestment,
            node.addressChangeCount,
            node.plusLeft,
            node.plusRight,
            node.proLeft,
            node.proRight,
            node.weeklyLeft,
            node.weeklyRight
        );
    }

    function getMyReferralCodes() external view returns (bytes32 leftReferralCode, bytes32 rightReferralCode) {
        require(users[msg.sender].id != 0, "User not registered");
        SBPLibrary.Node memory node = users[msg.sender];
        return (node.leftReferralCode, node.rightReferralCode);
    }

    function _updatePools(bytes32 levelHash, uint128 amount, bool isSbp) private {
        if (isSbp) {
            uint128 godShare = uint128((amount * 5) / 100);
            if (godShare > 0) {
                rewardToken.safeTransfer(god, godShare);
            }
        } else {
            uint128 godShare = uint128((amount * 5) / 100);
            uint128 weeklyShare = uint128((amount * 5) / 100);
            uint128 hourlyShare = uint128((amount * 90) / 100);
            if (levelHash == PLUS_HASH) {
                cacheA += hourlyShare;
                cacheC += weeklyShare;
            } else {
                cacheB += hourlyShare;
                cacheC += weeklyShare;
            }
            if (godShare > 0) {
                defaultToken.safeTransfer(god, godShare);
            }
            lastDepositTime = block.timestamp;
        }
    }

    function _airdropGift(address recipient, uint256 amount) private {
        require(address(rewardToken) != address(0), "Reward token not set");
        require(rewardToken.balanceOf(address(this)) >= amount, "Insufficient reward tokens");
        uint64 lockDuration = 365 days; 
        rewardToken.safeTransfer(recipient, amount);
        ISBP(address(rewardToken)).lockTokens(recipient, amount, lockDuration);
    }

    receive() external payable {}
}