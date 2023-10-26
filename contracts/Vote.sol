// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./DataStorage.sol";
import "./VersionController.sol";

contract Vote {
    bytes32 name;
    uint256 startTime;
    uint256 overTime;
    mapping(address => bool) voteStatus;
    DataStorage dataStorage;

    constructor(
        string memory _name, // 各种事件类型(What)
        address _addr, // user'address OR version'address(Who)
        uint _amount, // amount of currency, perpare for future.(How much)
        uint256 _start, //投票的有效期(When)
        uint256 _over,
        address _dsAddr
    ) {
        name = keccak256(abi.encodePacked(_name, _addr, _amount,  _start, _over));
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

    function getName() external view returns (bytes32) {
        return name;
    }
}

contract VoteFactory {
    Vote v;
    event logVote(string indexed name, uint256 startTime, uint256 overTime);
    address WCB;

    modifier WCBOnly() {
        require(
            msg.sender == WCB,
            "please create central bank via World Central Bank."
        );
        _;
    }

    constructor(address _WCB) {
        WCB = _WCB;
    }

    function createVote(
        string memory _name,
        address _addr, // user'address OR version'address
        uint _amount, // amount of currency, perpare for future.
        uint256 _start,
        uint256 _over,
        address _ds
    ) external {
        v = new Vote(_name, _addr, _amount, _start, _over, _ds);
        emit logVote(_name, _start, _over);
    }
}
