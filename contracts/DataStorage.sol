// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./CentralBank.sol";
import "./Vote.sol";

contract DataStorage {
    address WCB;

    // Ownership既可以生成交易，也可以参与决策
    address[] internal owners;
    mapping(address => bool) isOwner;

    // Membership仅可以生成交易，不可以参与决策
    address[] public members;
    mapping(address => bool) isMember;

    //VersionController
    //当前的WCB的地址,各种交易类型的版本
    //mapping(address => bool) version;
    //投票功能被作为单独的功能分离
    //为每一个投票事件单独创建智能合约
    //mapping(bytes32 => mapping(address => bool)) eventVotes;

    // 用来储存CBs和BAs
    address[] centralBanks;
    mapping(address => address) hasCentralBank;
    address[] businessAccounts;
    mapping(address => address) hasBusinessAccount;

    uint constant ZERO = 0;
    string constant ADDOWNER = "ADDOWNER";

    //event logUpdateVersion(uint timestamp, address newVersion);

    constructor(address[] memory _owners, address _wcb) {
        for (uint16 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }
        WCB = _wcb;
    }

    modifier ownersOnly() {
        require(isOwner[msg.sender] == true, "You must be Ownership to do it.");
        _;
    }

    modifier WCBOnly() {
        require(msg.sender == WCB, "Please Call it via WCB.");
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
            vote.getName() ==
                keccak256(
                    abi.encodePacked(_name, _addr, _amount, _start, _over)
                ),
            "Not this proposal."
        );
        require(vote.checkPass(), "Not pass.");
        _;
    }

    //Ownership的方法
    // function addOwner(
    //     address _voteAddr,
    //     address _addr,
    //     uint _start,
    //     uint _over
    // ) external passOnly(_voteAddr, ADDOWNER, _addr, ZERO , _start, _over) {
    //     owners.push(_addr);
    // }
    function addOwner(address _uaddr) external {
        owners.push(_uaddr);
        isOwner[_uaddr] = true;
    }

    function deleteOwner(address _uaddr) external {}

    function checkOwner(address _uaddr) external view returns (bool) {
        return isOwner[_uaddr];
    }

    // 关于member的方法
    function addMember(address _uaddr) external {
        members.push(_uaddr);
        isMember[_uaddr] = true;
    }

    function checkMember(address _uaddr) external view returns (bool) {
        return isMember[_uaddr];
    }

    // 关于CB的方法
    function addCentralBank(address _addr) external {
        centralBanks.push(_addr);
    }

    function addBusinessAccount(address _addr) external WCBOnly{
        centralBanks.push(_addr);
    }

    //Version的方法
    // function updateVersion(address _oldVersion, address _newVersion) external {
    //     version[_newVersion] = true;
    //     version[_oldVersion] = false;
    //     emit logUpdateVersion(block.timestamp, _newVersion);
    // }

    // function checkVersion(address _addr) external view returns (bool) {
    //     return version[_addr];
    // }

    function getCBAddr(uint _index) external view returns (address addr) {
        addr = members[_index];
    }

    function getCBLength() external view returns (uint) {
        return members.length;
    }
}
