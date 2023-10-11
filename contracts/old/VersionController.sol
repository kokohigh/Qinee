// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
// import "./MultiOwnership.sol";
// import "./DataStorage.sol";

// contract VersionController is MultiOwnership {
//     uint internal version;
//     DataStorage dataStorge;

//     event logUpdateVersion(uint timestamp, uint version);

//     modifier newVersionOnly(uint _ver) virtual {
//         require(version == _ver, "Vension conflict.");
//         _;
//     }

//     modifier majorityOnly(){
        
//         _;
//     }

//     constructor(address[] memory _owners, address _ds) MultiOwnership(_owners) {
//         dataStorge = DataStorage(_ds);
//     }

//     function updateVersion(uint _newVer) public majorityOnly{
//         version = _newVer;
//         emit logUpdateVersion(block.timestamp, _newVer);
//     }

//     function getVersion() external view returns (uint) {
//         return version;
//     }
// }
