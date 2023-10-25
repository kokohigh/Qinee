// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./Vote.sol";

contract DataStorage {
    //VersionController
    //当前的WCB的地址,各种交易类型的版本
    mapping(address => bool) version;

    // Ownership 对应于 CentralBank
    address[] internal owners;
    mapping(address => bool) isOwner;

    // Member 对应于 BusinessAccount
    address[] public members;
    mapping(address => bool) isMember;

    // Central Banks
    address[] centralBanks;
    mapping(address => bool) isCentralBank;
    //mapping(address => address) cbOfCountry;

    // Business Accounts
    address[] businessAccounts;
    mapping(address => bool) isBusinessAccount;

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

    // Version的方法
    function updateVersion(address _oldVersion, address _newVersion) external {
        version[_newVersion] = true;
        version[_oldVersion] = false;
        emit logUpdateVersion(block.timestamp, _newVersion);
    }

    function addVersion(address _version) external {
        version[_version] =true;
    }

    function checkVersion(address _addr) external view returns (bool) {
        return version[_addr];
    }

    // Ownership的方法
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

    // 关于中央银行的方法
    function addCentralBank(address _addr) external {
        centralBanks.push(_addr);
        isCentralBank[_addr] = true;
    }

    function checkCentralBank(address _addr) external view returns (bool) {
        return isCentralBank[_addr];
    }

    // 关于membership的方法
    function addMember(address _uaddr) external {
        members.push(_uaddr);
        isMember[_uaddr] = true;
    }

    function checkMember(address _uaddr) external view returns (bool) {
        return isMember[_uaddr];
    }

    // 关于商业账户的方法
    function addBusinessAccount(address _addr) external {
        businessAccounts.push(_addr);
        isBusinessAccount[_addr] = true;
    }

    function checkParticipants(address _addr) external view returns (bool) {
        return (isCentralBank[_addr] || isBusinessAccount[_addr]);
    }

    // 关于投票和央行的方法
    function getCBAddr(uint _index) external view returns (address addr) {
        addr = centralBanks[_index];
    }

    function getCBLength() external view returns (uint) {
        return centralBanks.length;
    }

    function listCB() external view returns (address[] memory){
        return centralBanks;
    }
}
