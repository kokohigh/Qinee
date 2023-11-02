//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./VersionController.sol";
import "./StandardFunctionsSet/Remittance.sol";
import "./StandardFunctionsSet/Collection.sol";
import "./StandardFunctionsSet/LetterOfCredit.sol";
import "./DataStorage.sol";

//The contract of country's central bank
contract CentralBank {
    string constant checkRemittance = "checkRemitance()";
    string constant checkCollection = "checkCollection()";
    string constant checkLOC = "checkLOC()";

    address immutable Owner;
    address VC;

    event logCreateByCall(bool success, bytes data);
    event logVoteSuccess(address _vote, bool success);

    modifier ownerOnly() {
        require(msg.sender == Owner, "Ownership is needed.");
        _;
    }

    modifier newVersionOnly(address _factory, string memory _func) {
        (bool success, bytes memory respond) = VC.call(
            abi.encodeWithSignature(_func)
        );
        address factoryVersion = abi.decode(respond, (address));
        require(_factory == factoryVersion, "Version deny.");
        _;
    }

    constructor(address _addr, address _vc) {
        Owner = _addr;
        VC = _vc;
    }

    function showOwner() external view returns (address) {
        return Owner;
    }

    //newVersionOnly(_rem, checkRemittance)
    function createRemittance(
        address _rem,
        address _to
    ) external payable ownerOnly  {
        RemittanceFactory(_rem).createRemittance{value: msg.value}(
            Owner,
            _to
        );
    }

    function createCollection(
        address _coll,
        address _im,
        uint _amount
    ) external payable ownerOnly newVersionOnly(_coll, checkCollection) {
        CollectionFactory(_coll).createCollection{value: msg.value}(
            Owner,
            _im,
            _amount
        );
    }

    function createLetterOfCredit(
        address _loc,
        address _ex,
        address _oracle,
        uint _ddl
    ) external payable ownerOnly newVersionOnly(_loc, checkLOC) {
        LetterOfCreditFactory(_loc).createLetterOfCredit{value: msg.value}(
            _ex,
            Owner,
            _oracle,
            _ddl
        );
    }

    function createByCall(address _addr, string memory _signature)
        external
        payable
        ownerOnly
    {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature(_signature)
        );
        emit logCreateByCall(success, data);
    }

    function createByCall(
        address _addr,
        string memory _signature,
        address _ex,
        address _im
    ) external payable ownerOnly {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature(_signature, _ex, _im)
        );
        emit logCreateByCall(success, data);
    }

    function createByCall(
        address _addr,
        string memory _signature,
        address _ex,
        address _im,
        address _oracle
    ) external payable ownerOnly {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature(_signature, _ex, _im, _oracle)
        );
        emit logCreateByCall(success, data);
    }

    function affirmativeVote(address _vote) external ownerOnly {
        (bool success, ) = _vote.call(
            abi.encodeWithSignature("affirmativeVote()")
        );
        emit logVoteSuccess(_vote, success);
    }

    function dissentingVote(address _vote) external ownerOnly {
        (bool success, ) = _vote.call(
            abi.encodeWithSignature("dissentingVote()")
        );
        emit logVoteSuccess(_vote, success);
    }

    function getVoteName(address _vote) external ownerOnly {}

    // //我怀疑钱被卡在了这个合约， 用这个方法检查
    // //？？？
    // function getValue() external view returns(uint){
    //     return address(this).balance;
    // }
}

contract CentralBankFactory {
    CentralBank centralbank;
    DataStorage dataStorage;
    address WCB;
    address VC;

    event logCentralBank(
        CentralBank indexed centralbank,
        address indexed owner,
        uint timestamp
    );

    modifier WCBOnly() {
        require(WCB == msg.sender, "Please create central bank via WCB.");
        _;
    }

    // modifier OwnershipOnly(address _uaddr) {
    //     require(dataStorage.checkOwner(_uaddr), "No permission to create central bank.");
    //     _;
    // }

    constructor(
        address _ds,
        address _wcb,
        address _vc
    ) {
        dataStorage = DataStorage(_ds);
        WCB = _wcb;
        VC = _vc;
    }

    function createCentralBank(address _owner) public WCBOnly {
        centralbank = new CentralBank(_owner, VC);
        dataStorage.addCentralBank(address(centralbank), _owner);
        emit logCentralBank(centralbank, _owner, block.timestamp);
    }

    function checkWCB() external view returns (address) {
        return WCB;
    }

    function checkSender() external view returns (address) {
        return msg.sender;
    }
}
