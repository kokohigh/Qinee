// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./CentralBank.sol";
import "./Vote.sol";

contract DataStorage {
    address public WCB;
    address public VC;

    // Ownership既可以生成交易，也可以参与决策
    address[] internal owners;
    mapping(address => bool) isOwner;

    // Membership仅可以生成交易，不可以参与决策
    address[] internal members;
    mapping(address => bool) isMember;

    // 用来储存CBs和BAs
    address[] centralBanks;
    mapping(address => address) countryToCentralBank;
    address[] businessAccounts;
    mapping(address => address) countryToBusinessAccount;

    constructor(address[] memory _owners, address _vc) {
        for (uint16 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }
        VC = _vc;

    }

    modifier ownersOnly() {
        require(isOwner[msg.sender] == true, "You must be Ownership to do it.");
        _;
    }

    modifier WCBOnly() {
        require(WCB == msg.sender, "Please Call it via WCB.");
        _;
    }

    function getWCB() external {
        (, bytes memory respond) = VC.call(abi.encodeWithSignature("checkWCB()"));
        WCB = abi.decode(respond, (address));
    }

    function addOwner(
        address _uaddr
    ) external WCBOnly {
        owners.push(_uaddr);
        isOwner[_uaddr] = true;
    }

    function deleteOwner(address _uaddr) external {}

    function checkOwner(address _uaddr) external view returns (bool) {
        return isOwner[_uaddr];
    }

    // 关于member的方法
    function addMember(address _uaddr) external WCBOnly{
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
    function addCentralBank(address _addr, address _owner) external {
        // 这里的控制器应该是最新的CBFactory
        centralBanks.push(_addr);
        countryToCentralBank[_owner] = _addr;
        countryToCentralBank[_addr] = _owner;
    }

    function addBusinessAccount(address _addr, address _owner) external {
        // 这里的控制器应该是最新的BAFactory
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

    function checkIsCB(address _addr) external view returns (bool isCB) {
        isCB = (countryToCentralBank[_addr] != address(0) &&
            isOwner[_addr] != true);
    }

    function getCBAddr(uint _index) external view returns (address addr) {
        addr = centralBanks[_index];
    }

    function getCBLength() external view returns (uint) {
        return centralBanks.length;
    }

    function checkSender() external view returns (address user){
        user = msg.sender;
    }
}
