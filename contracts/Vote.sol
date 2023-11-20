// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./DataStorage.sol";
import "./VersionController.sol";

contract Vote {
    bytes32 internal name;
    uint256 internal startTime;
    uint256 internal overTime;
    mapping(address => bool) voteStatus;
    DataStorage dataStorage;

    constructor(
        // 用纯大写来表示事件类型
        // ADDVERSION
        // ADDSFSVERSION
        // ADDOWNER
        // ADDMEMBER
        string memory _name, // 各种事件类型(What)
        address _addr, // user'address OR version'address(Who)
        uint _amount, // amount of currency, perpare for future.(How much)
        uint256 _start, //投票的有效期(When)开始时刻
        uint256 _over, //投票的结束时刻
        address _dsAddr //用于检查是否通过的data storage
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

    modifier voteOverOnly(){
        require(block.timestamp > overTime, "Voting in progress.");
        _;
    }

    modifier OwnerOnly() {
        require(
            dataStorage.checkOwner(msg.sender),
            "Don't have owner permisson"
        );
        _;
    }

    modifier CBOnly() {
        require(dataStorage.checkIsCB(msg.sender), "Please vote via central bank.");
        _;
    }

    function affirmativeVote() external validatyOnly CBOnly {
        voteStatus[msg.sender] = true;
    }

    function dissentingVote() external validatyOnly CBOnly {
        voteStatus[msg.sender] = false;
    }

    //TODO 完成datastorage的重写后
    function checkPass() external view voteOverOnly returns (bool) {
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
    event logVote(address vote, uint256 startTime, uint256 overTime);
    address public WCB;
    address public DS;

    modifier WCBOnly() {
        require(
            msg.sender == WCB,
            "please create vote via World Central Bank."
        );
        _;
    }

    constructor(address _WCB, address _ds) {
        WCB = _WCB;
        DS = _ds;
    }

    function createVote(
        string memory _name, // UPDATEVERSION 
        address _addr, // user'address OR version'address
        uint _amount, // amount of currency, perpare for future.
        uint256 _start,
        uint256 _over
    ) external {
        v = new Vote(_name, _addr, _amount, _start, _over, DS);
        emit logVote(address(v), _start, _over);
    }
}
