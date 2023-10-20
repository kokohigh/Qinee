// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./CentralBank.sol";
import "./Vote.sol";

contract DataStorage {
    // Ownership
    address[] internal owners;
    mapping(address => bool) isOwner;

    //VersionController
    //当前的WCB的地址,各种交易类型的版本
    mapping(address => bool) version;

    //Owner和Member的区别为以后将更多主体纳入系统预留了空间
    //目前两者一致
    address[] public members;
    mapping(address => bool) isMember;

    //投票功能被作为单独的功能分离
    //为每一个投票事件单独创建智能合约
    //mapping(bytes32 => mapping(address => bool)) eventVotes;

    CentralBank[] centralBanks;

    uint constant ZERO = 0;
    string constant ADDOWNER = "ADDOWNER";

    event logUpdateVersion(uint timestamp, address newVersion);

    constructor(address[] memory _owners) {
        for (uint16 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }
    }

    modifier ownersOnly() {
        require(isOwner[msg.sender] == true, "You must be Ownership to do it.");
        _;
    }

    modifier passOnly(
        address _vote,
        string memory _name,
        address _addr,
        uint _amount,
        uint _start,
        uint _over
    ) {
        Vote vote = Vote(_vote);
        require(
            vote.getName() == keccak256(abi.encodePacked(_name, _addr, _amount, _start, _over)),
            "Not this proposal."
        );
        require(vote.checkPass(), "Not pass.");
        _;
    }

    //Ownership的方法
    function addOwner(
        address _voteAddr,
        address _addr,
        uint _start,
        uint _over
    ) external passOnly(_voteAddr, ADDOWNER, _addr, ZERO , _start, _over) {
        owners.push(_addr);
    }

    function deleteOwner(address _addr) external {}

    function checkOwner(address _addr) external view returns (bool) {
        return isOwner[_addr];
    }

    //Version的方法
    function updateVersion(address _oldVersion, address _newVersion) external {
        version[_newVersion] = true;
        version[_oldVersion] = false;
        emit logUpdateVersion(block.timestamp, _newVersion);
    }

    function checkVersion(address _addr) external view returns (bool) {
        return version[_addr];
    }

    //写一些关于数据操作的方法
    function addCentralBank(CentralBank _addr) external {
        centralBanks.push(_addr);
    }

    function addMember(address _uaddr) external {
        members.push(_uaddr);
        isMember[_uaddr] = true;
    }

    // function vote(bytes32 _name, address _uaddr) external {
    //     eventVotes[_name][_uaddr] = true;
    // }

    // function revocation(bytes32 _name, address _uaddr) external {
    //     eventVotes[_name][_uaddr] = false;
    // }

    function checkMember(address _uaddr) external view returns (bool) {
        return isMember[_uaddr];
    }

    function getCBAddr(uint _index) external view returns (address addr) {
        addr = members[_index];
    }

    function getCBLength() external view returns (uint) {
        return members.length;
    }

    // function checkVote(bytes32 _name, address _uaddr)
    //     external
    //     view
    //     returns (bool)
    // {
    //     return eventVotes[_name][_uaddr];
    // }
}
