// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./CentralBank.sol";
import "./DataStorage.sol";
import "./Vote.sol";

//The contract of WCB
contract WorldCentralBank {
    DataStorage dataStorage;

    constructor(address _ds) {
        dataStorage = DataStorage(_ds);
    }

    modifier membersOnly() {
        require(dataStorage.checkMember(msg.sender), "Menbership is needed.");
        _;
    }

    function createCentralBank(address _CBFactory, address _owner) external {
        require(
            dataStorage.checkMember(msg.sender) == false,
            "Already initialed the central bank."
        );
        CentralBankFactory(_CBFactory).creatCentralBank(_owner);
        dataStorage.addMember(msg.sender);
    }

    function creatVote(
        address _voteFactory,
        string memory _name,
        uint256 _start,
        uint256 _over,
        address _ds
    ) external {
        require(
            dataStorage.checkOwner(msg.sender),
            "You need Owner Permission."
        );
        VoteFactor(_voteFactory).createVote(_name, _start, _over, _ds);
    }

    // function vote(string memory _eventName) external {
    //     bytes32 name = keccak256(abi.encodePacked(_eventName));
    //     dataStorage.vote(name, msg.sender);
    // }

    // function revocation(string memory _eventName) external {
    //     bytes32 name = keccak256(abi.encodePacked(_eventName));
    //     dataStorage.revocation(name, msg.sender);
    // }

    // function checkPass(string memory _eventName)
    //     external
    //     view
    //     returns (bool result)
    // {
    //     bytes32 name = keccak256(abi.encodePacked(_eventName));
    //     uint approval = 0;
    //     uint Length = 0;
    //     Length = dataStorage.getCBLength();
    //     for (uint i = 0; i < Length; i++) {
    //         address addr = dataStorage.getCBAddr(i);
    //         if (dataStorage.checkVote(name, addr) == true) {
    //             approval += 1;
    //         }
    //     }
    //     if (approval > Length / 2) {
    //         return true;
    //     } else {
    //         return false;
    //     }
    //}

    // function checkVote(string memory _eventName) external view returns (bool) {
    //     bytes32 name = keccak256(abi.encodePacked(_eventName));
    //     return dataStorage.checkVote(name, msg.sender);
    // }
}
