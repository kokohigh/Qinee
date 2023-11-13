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

    // 用来储存CBs和BAs
    address[] centralBanks;
    mapping(address => address) countryToCentralBank;
    address[] businessAccounts;
    mapping(address => address) countryToBusinessAccount;

    uint constant ZERO = 0;
    string constant ADDOWNER = "ADDOWNER";

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

    // 检查是不是Owner或Member
    // function checkParticipants(address _addr) external view returns (bool) {
    //     return isOwner[_addr] || isMember[_addr];
    // }

    // 关于CB的方法
    function addCentralBank(address _addr, address _owner) external { //WCBOnly
        centralBanks.push(_addr);
        countryToCentralBank[_owner] = _addr;
        countryToCentralBank[_addr] = _owner;
    }

    function addBusinessAccount(address _addr, address _owner)
        external
    {
        centralBanks.push(_addr);
        countryToBusinessAccount[_owner] = _addr;
        countryToBusinessAccount[_addr] = _owner;
    }

    function checkHasCB(address _uaddr) external view returns (address) {
        return countryToCentralBank[_uaddr];
    }

    function checkHasBA(address _uaddr) external view returns (address) {
        return countryToBusinessAccount[_uaddr];
    }

    function checkIsCBBA(address _uaddr) external view returns (bool isCBBA) {
        isCBBA =
            countryToBusinessAccount[_uaddr] != address(0) ||
            countryToCentralBank[_uaddr] != address(0);
    }

    function getCBAddr(uint _index) external view returns (address addr) {
        addr = members[_index];
    }

    function getCBLength() external view returns (uint) {
        return members.length;
    }
}
