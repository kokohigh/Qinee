// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./CentralBank.sol";

contract DataStorage {
    address[] owners;
    mapping(address => bool) isOwner;

    CentralBank[] centralBanks;

    address[] public members;
    mapping(address => bool) isMember;

    mapping(bytes32 => mapping(address => bool)) eventVotes;

    //写一些关于数据操作的方法
    function addOwner(address _addr) internal {
        owners.push(_addr);
    }

    function deleteOwner(address _addr) internal {}

    function addCentralBank(CentralBank _addr) external {
        centralBanks.push(_addr);
    }

    function addMember(address _uaddr) external {
        isMember[_uaddr] = true;
    }

    function vote(bytes32 _name, address _uaddr) external {
        eventVotes[_name][_uaddr] = true;
    }

    function revocation(bytes32 _name, address _uaddr) external {
        eventVotes[_name][_uaddr] = false;
    }

    function checkMember(address _uaddr) external view returns (bool) {
        return isMember[_uaddr];
    }

    function getCBAddr(uint _index) external view returns (address addr) {
        addr = members[_index];
    }

    function getCBLength() external view returns (uint l) {
        l = members.length;
    }

    function checkVote(bytes32 _name, address _uaddr) external view returns (bool){ 
        return eventVotes[_name][_uaddr];
    }
}
