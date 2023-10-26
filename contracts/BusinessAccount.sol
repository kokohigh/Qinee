//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./StandardFunctionsSet/Remittance.sol";
import "./StandardFunctionsSet/Collection.sol";
import "./StandardFunctionsSet/LetterOfCredit.sol";
import "./DataStorage.sol";

//The contract of country's central bank
contract BusinessAccount {
    address immutable Owner;

    event logCreateByCall(bool success, bytes data);

    modifier ownerOnly() {
        require(msg.sender == Owner, "Ownership is needed.");
        _;
    }

    constructor(address _addr) {
        Owner = _addr; //好像可以利用代理调用直接取得msg.sender
    }

    function showOwner() external view returns (address) {
        return Owner;
    }

    function createRemittance(address _rem, address _to)
        public
        payable
        ownerOnly
    {
        RemittanceFactory(_rem).createRemittance{value: msg.value}(Owner, _to);
        //_wcb.transfer(address(this).address);
    }

    function createCollection(
        address _coll,
        address _im,
        uint _amount,
        address _ds
    ) external payable ownerOnly {
        CollectionFactory(_coll).createCollection{value: msg.value}(
            Owner,
            _im,
            _amount,
            _ds
        );
    }

    function createLetterOfCredit(
        address _loc,
        address _ex,
        address _oracle,
        uint _ddl,
        address _ds
    ) external payable ownerOnly {
        LetterOfCreditFactory(_loc).createLetterOfCredit{value: msg.value}(
            _ex,
            Owner,
            _oracle,
            _ddl,
            _ds
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
}

contract BusinessAccountFactory {
    BusinessAccount businessAccount;
    DataStorage dataStorage;
    address WCB;

    event logBusinessAccount(
        BusinessAccount indexed businessAccount,
        address indexed owner,
        uint timestamp
    );

    modifier WCBOnly() {
        require(
            msg.sender == WCB,
            "please create central bank via World Central Bank."
        );
        _; //todo
    }

    constructor(address _ds, address _wcb) {
        dataStorage = DataStorage(_ds);
        WCB = _wcb;
    }

    function createBusinessAccount(address _owner) public WCBOnly {
        businessAccount = new BusinessAccount(_owner);
        dataStorage.addBusinessAccount(address(businessAccount));
        emit logBusinessAccount(businessAccount, _owner, block.timestamp);
    }
}
