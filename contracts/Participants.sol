// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Storage.sol";

contract Participants is Storage{
    // address[] public participants;
    // mapping(address => bool) isJoined;

    modifier noJoined(){
        require(isJoined[msg.sender]==false,"You have already joined WCB.");
        _;
    }
    
    function joinWCB() public noJoined(){
        participants.push(msg.sender);
        isJoined[msg.sender] = true;
    }


}