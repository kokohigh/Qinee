// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Storage.sol";

contract MultiOwnership is Storage{
    modifier ownersOnly(){
        require(isOwner[msg.sender] == true,"You must be Ownership to do it.");
        _;
    }

    
}