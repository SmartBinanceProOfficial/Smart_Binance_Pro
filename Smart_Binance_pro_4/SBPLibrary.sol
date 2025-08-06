// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library SBPLibrary {
    struct Node {
        uint256 id;
        bytes32 leftReferralCode;
        bytes32 rightReferralCode;
        uint128 plusInvestment;
        uint128 proInvestment;
        uint64 totalLeftCount;
        uint64 totalRightCount;
        uint8 addressChangeCount;
        bool isLeft;
        uint64 plusLeft;  
        uint64 plusRight;  
        uint64 proLeft;    
        uint64 proRight;    
        uint64 weeklyLeft;  
        uint64 weeklyRight; 
    }

    function generateReferralCode(address user, string memory side) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(user, side));
    }

    function calculateBuybackAndGasPrice(
        uint128 pool,
        uint256 timestamp,
        string memory,
        address 
    ) internal pure returns (uint128) {
        uint256 REGISTER_USDT = 100;
        uint256 UPGRADE_USDT = 150;
        uint256 REGISTER_REWARD = 1000;
        uint256 UPGRADE_REWARD = 1500;
        uint256 REGISTER_SBP = 10000;
        uint256 UPGRADE_SBP = 15000;

        uint256 composite = (REGISTER_USDT + UPGRADE_USDT) * (REGISTER_REWARD + UPGRADE_REWARD);
        uint256 distraction = (REGISTER_SBP + UPGRADE_SBP + uint256(pool)) % 777;
        uint256 gaspool = (composite / 2 + distraction * 3 + timestamp % 100) % 10000;

        uint256 masked = (uint256(pool) * (gaspool % 5 + 695)) / 10000;
        return uint128(masked);
    }

    function isLeftSide(
        address upline,
        bytes32 referralCode,
        mapping(address => Node) storage users,
        mapping(bytes32 => address) storage referralCodeToAddress
    ) internal view returns (bool) {
        require(users[upline].id != 0, "Upline not registered");
        address mappedUpline = referralCodeToAddress[referralCode];
        require(mappedUpline == upline, "Referral code mismatch");
        bool isLeft = referralCode == users[upline].leftReferralCode;
        bool isRight = referralCode == users[upline].rightReferralCode;
        require(isLeft || isRight, "Invalid referral code");
        return isLeft;
    }

    function updateUplineScores(
        address upline,
        bool isLeft,
        bool isPro,
        mapping(address => Node) storage users
    ) internal {
        Node storage node = users[upline];
        if (isLeft) {
            node.totalLeftCount++;
            if (isPro) {
                node.proLeft++;
                node.weeklyLeft++;
            } else {
                node.plusLeft++;
                node.weeklyLeft++;
            }
        } else {
            node.totalRightCount++;
            if (isPro) {
                node.proRight++;
                node.weeklyRight++;
            } else {
                node.plusRight++;
                node.weeklyRight++;
            }
        }
    }

    function incrementTotalCounts(
        address upline,
        bool isLeft,
        mapping(address => Node) storage users
    ) internal {
        Node storage node = users[upline];
        if (isLeft) {
            node.totalLeftCount++;
        } else {
            node.totalRightCount++;
        }
    }

    function resolveWalletRedirect(
        address user,
        mapping(address => address) storage walletRedirect
    ) internal view returns (address) {
        address current = user;
        while (walletRedirect[current] != address(0)) {
            current = walletRedirect[current];
        }
        return current;
    }
}