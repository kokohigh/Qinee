// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
<<<<<<< HEAD
import "./VersionController.sol";
import "./DataStorage.sol";
=======
>>>>>>> parent of a18c593 (add version controller and business account)
import "./CentralBank.sol";
import "./DataStorage.sol";
import "./Vote.sol";

//The contract of WCB
contract WorldCentralBank {
    VersionController VC;
    DataStorage dataStorage;

    constructor(address _vc) {
        VC = VersionController(_vc);
    }

    modifier membersOnly() {
        require(dataStorage.checkMember(msg.sender), "Menbership is needed.");
        _;
    }

    function updateDS() external {
        dataStorage = DataStorage(VC.checkDS()); // 自动装载DS
    }

    function createCentralBank() external {
        require(
            dataStorage.checkMember(msg.sender) == false ||
            dataStorage.checkOwner(msg.sender) == true,
            "Already initialed the central bank."
        );
<<<<<<< HEAD
        CentralBankFactory(VC.checkCB()).createCentralBank(msg.sender);
        dataStorage.addMember(msg.sender); //addMember?
    }

        function createBusinessAccount() external {
        require(
            dataStorage.checkMember(msg.sender) == false,
            "Already initialed the central bank."
        );
        BusinessAccountFactory(VC.checkBA()).createBusinessAccount(msg.sender);
        dataStorage.addMember(msg.sender); //addMember
=======
        CentralBankFactory(_CBFactory).creatCentralBank(msg.sender);
        dataStorage.addMember(msg.sender);
>>>>>>> parent of a18c593 (add version controller and business account)
    }

    function createVote(
        string memory _name,
        address _uaddr,
        uint256 _amount,
        uint256 _start,
        uint256 _over
    ) external {
        require(
            dataStorage.checkOwner(msg.sender),
            "You need Owner Permission."
        );
        VoteFactory(VC.checkVote()).createVote(_name, _uaddr, _amount, _start, _over);
    }

    function checkDataStoage() view external returns(address, DataStorage){
        return (address(dataStorage), dataStorage);
    }

    function checkCentralBank() view external returns (address){
        return address(this);// TODO
    }
}
