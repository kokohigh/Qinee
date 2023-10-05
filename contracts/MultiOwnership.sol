// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract MultiOwnership{
    address[] internal owners;
    mapping(address => bool) isOwner;
    constructor(address[] memory _owners){
        for(uint16 i = 0; i<_owners.length; i++){
            owners.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }
    }
    modifier ownersOnly(){
        require(isOwner[msg.sender] == true,"You must be Ownership to do it.");
        _;
    }

    
}