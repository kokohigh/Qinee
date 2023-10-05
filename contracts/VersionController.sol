// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./DataStorage.sol";

contract VersionController{
    address internal version;
    
    event logUpdateVersion(uint timestamp, address version);
    modifier newVersionOnly(address _ver){
        require(version == _ver, "Vension conflict.");
        _;
    }

    function updateVersion(address _newVer) public{
        version = _newVer;
        emit logUpdateVersion(block.timestamp, _newVer);
    }
}