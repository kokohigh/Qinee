// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./CentralBank.sol";
import "./BusinessAccount.sol";
import "./DataStorage.sol";
import "./Vote.sol";

//The contract of WCB
contract WorldCentralBank {
    // 数据储存
    DataStorage dataStorage;
    address VC;

    constructor(address _ds, address _vc) {
        dataStorage = DataStorage(_ds);
        VC = _vc;
    }

    modifier membersOnly() {
        require(dataStorage.checkMember(msg.sender), "Menbership is needed.");
        _;
    }

    modifier newCBFactoryOnly(address _CBFactory) {
        (bool success, bytes memory respond) = VC.call(abi.encodeWithSignature("checkCB()"));
        address CB = abi.decode(respond, (address));
        require(CB == _CBFactory, "Version deny.");
        _;
    }

    modifier newBAFactoryOnly(address _BAFactory) {
        (bool success, bytes memory respond) = VC.call(abi.encodeWithSignature("checkBA()"));
        address BA = abi.decode(respond, (address));
        require(BA == _BAFactory, "Version deny.");
        _;
    }

    modifier newVoteFactoryOnly(address _voteFactory) {
        (bool success, bytes memory respond) = VC.call(abi.encodeWithSignature("checkVote()"));
        address voteFactory = abi.decode(respond, (address));
        require(voteFactory == _voteFactory, "Version deny.");
        _;
    }

    function addOwner(address _uaddr) external {
        dataStorage.addOwner(_uaddr);
    }

    function addMember(address _uaddr) external {
        dataStorage.addMember(_uaddr);
    }

    function createCentralBank(address _CBFactory) external newCBFactoryOnly(_CBFactory){
        require(
            dataStorage.checkOwner(msg.sender) == true,
            "Already initialed the central bank."
        );
        CentralBankFactory(_CBFactory).createCentralBank(msg.sender);
    }

    function createBusinessAccount(address _BAFactory) external newBAFactoryOnly(_BAFactory){
        require(
            dataStorage.checkMember(msg.sender) == true,
            "Already initialed the central bank."
        );
        BusinessAccountFactory(_BAFactory).createBusinessAccount(msg.sender);
    }

    function createVote(
        address _vote,
        string memory _name,
        address _uaddr,
        uint256 _amount,
        uint256 _start,
        uint256 _over,
        address _ds
    ) external newVoteFactoryOnly(_vote){
        require(
            dataStorage.checkOwner(msg.sender),
            "You need Owner Permission."
        );
        VoteFactory(_vote).createVote(
            _name,
            _uaddr,
            _amount,
            _start,
            _over,
            _ds
        );
    }

    function checkDataStoage() external view returns (address) {
        return (address(dataStorage));
    }

    // function checkCentralBank() external view returns (address) {
    //     return address(this); // TODO
    // }
}
