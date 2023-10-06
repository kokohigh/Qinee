// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./MultiOwnership.sol";

contract VersionController is MultiOwnership {
    uint internal version;

    event logUpdateVersion(uint timestamp, uint version);

    modifier newVersionOnly(uint _ver) virtual {
        require(version == _ver, "Vension conflict.");
        _;
    }

    constructor(address[] memory _owners) MultiOwnership(_owners) {}

    function updateVersion(uint _newVer) public {
        version = _newVer;
        emit logUpdateVersion(block.timestamp, _newVer);
    }

    function getVersion() external view returns (uint) {
        return version;
    }
}
