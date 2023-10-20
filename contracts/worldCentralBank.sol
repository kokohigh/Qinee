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
        address _uaddr,
        uint256 _amount,
        uint256 _start,
        uint256 _over,
        address _ds
    ) external {
        require(
            dataStorage.checkOwner(msg.sender),
            "You need Owner Permission."
        );
        VoteFactor(_voteFactory).createVote(_name, _uaddr, _amount, _start, _over, _ds);
    }

    function checkDataStoage() view external returns(address, DataStorage){
        return (address(dataStorage), dataStorage);
    }
}
