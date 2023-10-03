// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Stroage.sol";

contract MultiOwnership{
    modifier ownersOnly(){
        require(Owners[msg.sender] == true,"You must be Ownership to do it.");
        _;
    }

    
}