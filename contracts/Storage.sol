// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Storage{
    address[] owners;
    mapping(address => bool) isOwner;

    address[] public participants;
    mapping(address => bool) isJoined;


    mapping(bytes32 => mapping(address => bool)) eventVotes;

    function addOwner(address _addr) internal{
        owners.push(_addr);
    }

    function deleteOwner(address _addr) internal{
        
    }

}