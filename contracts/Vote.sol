// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./DataStorage.sol";

contract Vote {
    bytes32 name;
    uint256 startTime;
    uint256 overTime;
    mapping(address => bool) voteStatus;
    DataStorage dataStorage;

    constructor(
        string memory _name,
        uint256 _start,
        uint256 _over,
        address _dsAddr
    ) {
        name = keccak256(abi.encodePacked(_name));
        startTime = _start;
        overTime = _over;
        dataStorage = DataStorage(_dsAddr);
    }

    //为投票设置有效期
    modifier validatyOnly() {
        require(
            block.timestamp <= overTime && block.timestamp >= startTime,
            "Out of validaty."
        );
        _;
    }

    modifier OwnerOnly() {
        require(
            dataStorage.checkOwner(msg.sender),
            "Don't have owner permisson"
        );
        _;
    }

    function affirmativeVote() external validatyOnly OwnerOnly {
        voteStatus[msg.sender] = true;
    }

    function dissentingVote() external validatyOnly OwnerOnly {
        voteStatus[msg.sender] = false;
    }

    //TODO 完成datastorage的重写后
    function checkPass() external view returns (bool) {
        uint approval = 0;
        uint Length = 0;
        Length = dataStorage.getCBLength();
        for (uint i = 0; i < Length; i++) {
            address addr = dataStorage.getCBAddr(i);
            if (voteStatus[addr] == true) {
                approval += 1;
            }
        }
        if (approval > Length / 2) {
            return true;
        } else {
            return false;
        }
    }
}

contract VoteFactor {
    Vote v;
    event logVote(string indexed name, uint256 startTime, uint256 overTime);

    function createVote(
        string memory _name,
        uint256 _start,
        uint256 _over,
        address _ds
    ) external {
        v = new Vote(_name, _start, _over, _ds);
        emit logVote(_name, _start, _over);
    }
}
